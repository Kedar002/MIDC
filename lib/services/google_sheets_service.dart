import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../models/work_data.dart';
import '../models/monitoring_data.dart';
import '../models/work_entry_data.dart';

class GoogleSheetsService {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _altDateFormat = DateFormat('M/d/yy');

  static const String _sheetUrlKey = 'google_sheet_url';
  static const String _sheetIdKey = 'google_sheet_id';
  static const String _isPublishedKey = 'google_sheet_is_published';

  // Platform-aware storage: SharedPreferences for web, File for desktop
  Future<void> _saveToStorage(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      final file = await _getConfigFile();
      final config = await _loadConfigFromFile();
      config[key] = value;
      await file.writeAsString(json.encode(config));
    }
  }

  Future<void> _saveBoolToStorage(String key, bool value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } else {
      final file = await _getConfigFile();
      final config = await _loadConfigFromFile();
      config[key] = value;
      await file.writeAsString(json.encode(config));
    }
  }

  Future<String?> _getFromStorage(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      final config = await _loadConfigFromFile();
      return config[key] as String?;
    }
  }

  Future<bool> _getBoolFromStorage(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? false;
    } else {
      final config = await _loadConfigFromFile();
      return config[key] as bool? ?? false;
    }
  }

  Future<void> _removeFromStorage(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      final file = await _getConfigFile();
      final config = await _loadConfigFromFile();
      config.remove(key);
      await file.writeAsString(json.encode(config));
    }
  }

  // File storage for desktop platforms
  Future<File> _getConfigFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/google_sheet_config.json');
  }

  Future<Map<String, dynamic>> _loadConfigFromFile() async {
    try {
      final file = await _getConfigFile();
      if (!await file.exists()) return {};
      final contents = await file.readAsString();
      return json.decode(contents) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  // Save connected Google Sheet URL
  Future<void> saveSheetConnection(String sheetUrl) async {
    final sheetId = _extractSheetId(sheetUrl);
    final isPublished = _isPublishedUrl(sheetUrl);

    if (sheetId == null) {
      throw Exception('Invalid Google Sheets URL');
    }

    await _saveToStorage(_sheetUrlKey, sheetUrl);
    await _saveToStorage(_sheetIdKey, sheetId);
    await _saveBoolToStorage(_isPublishedKey, isPublished);
  }

  // Check if URL is a published URL
  bool _isPublishedUrl(String url) {
    return url.contains('/pub?output=csv') || url.contains('/d/e/2PACX-');
  }

  // Extract actual GIDs from edit URL if available
  Future<Map<String, String>> _getActualSheetGids(String sheetUrl) async {
    // For now, return default GIDs - we'll fetch them dynamically later
    // The sheets should be in order: DPR (0), Work (1), Monitoring (2), Work Entry (3)
    return {
      'DPR': '0',
      'Work': '1',
      'Monitoring': '2',
      'Work Entry': '3',
    };
  }

  // Get connected Google Sheet URL
  Future<String?> getConnectedSheetUrl() async {
    try {
      return await _getFromStorage(_sheetUrlKey);
    } catch (e) {
      return null;
    }
  }

  // Get connected Google Sheet ID
  Future<String?> getConnectedSheetId() async {
    try {
      return await _getFromStorage(_sheetIdKey);
    } catch (e) {
      return null;
    }
  }

  // Check if connected sheet is published URL
  Future<bool> _isConnectedSheetPublished() async {
    try {
      return await _getBoolFromStorage(_isPublishedKey);
    } catch (e) {
      return false;
    }
  }

  // Disconnect Google Sheet
  Future<void> disconnectSheet() async {
    try {
      await _removeFromStorage(_sheetUrlKey);
      await _removeFromStorage(_sheetIdKey);
      await _removeFromStorage(_isPublishedKey);
    } catch (e) {
      // Ignore errors
    }
  }

  // Check if a sheet is connected
  Future<bool> isSheetConnected() async {
    final sheetId = await getConnectedSheetId();
    return sheetId != null;
  }

  // Extract Sheet ID from URL
  String? _extractSheetId(String url) {
    // Published URL format: https://docs.google.com/spreadsheets/d/e/2PACX-.../pub?output=csv
    if (url.contains('/d/e/2PACX-')) {
      final regex = RegExp(r'/d/e/(2PACX-[a-zA-Z0-9-_]+)');
      final match = regex.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }

    // Edit URL format: https://docs.google.com/spreadsheets/d/{SHEET_ID}/edit...
    final regex = RegExp(r'/spreadsheets/d/([a-zA-Z0-9-_]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  // Get GID (sheet tab ID) from sheet name
  Map<String, String> _getSheetGids() {
    return {
      'DPR': '0',        // First sheet is usually 0
      'Work': '1',
      'Monitoring': '2',
      'Work Entry': '3',
    };
  }

  // Sync (read) data from Google Sheets
  Future<List<Project>> syncFromGoogleSheets() async {
    final sheetId = await getConnectedSheetId();

    if (sheetId == null) {
      throw Exception('No Google Sheet connected');
    }

    final projects = <Project>[];
    final projectMap = <String, Project>{};

    try {
      // Read all sheets
      await _readDPRSheet(sheetId, projectMap);
      await _readWorkSheet(sheetId, projectMap);
      await _readMonitoringSheet(sheetId, projectMap);
      await _readWorkEntrySheet(sheetId, projectMap);
    } catch (e) {
      // Add more context to the error
      throw Exception('Failed to sync sheets: $e\n\nMake sure your sheet is published to web:\nFile → Share → Publish to web → Entire Document → CSV');
    }

    projects.addAll(projectMap.values);

    if (projects.isEmpty) {
      throw Exception('No projects found in Google Sheet. Please check:\n1. Sheet is published to web\n2. Sheet has data in the expected format');
    }

    return projects;
  }

  Future<void> _readDPRSheet(String sheetId, Map<String, Project> projectMap) async {
    // Fetch DPR sheet with correct GID
    String csvData;
    try {
      csvData = await _fetchSheetAsCSV(sheetId, '1015103094');
    } catch (e) {
      print('Error fetching DPR sheet: $e');
      rethrow;
    }
    final rows = const CsvToListConverter().convert(csvData);
    print('DPR Sheet: Found ${rows.length} rows');

    // Skip header rows (0-1)
    for (int rowIndex = 2; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];

      if (row.isEmpty || row[0] == null || row[0].toString().trim().isEmpty) continue;

      // Skip category headers (A, B, C, D, E)
      if (row[0].toString().length == 1 && RegExp(r'[A-E]').hasMatch(row[0].toString())) continue;

      final projectName = row.length > 1 ? row[1]?.toString().trim() : null;
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategoryFromSheet(rows, rowIndex),
          srNo: rowIndex - 1,
        ),
      );

      project.dprData ??= DPRData();

      // Map columns
      project.dprData!.broadScope = row.length > 2 ? row[2]?.toString() : null;
      project.dprData!.bidDocDPRDate = row.length > 3 ? _parseDate(row[3]) : null;
      project.dprData!.tenderInviteDate = row.length > 4 ? _parseDate(row[4]) : null;
      project.dprData!.prebidDate = row.length > 5 ? _parseDate(row[5]) : null;
      project.dprData!.csdDate = row.length > 6 ? _parseDate(row[6]) : null;
      project.dprData!.bidSubmitDate = row.length > 7 ? _parseDate(row[7]) : null;
      project.dprData!.workOrderDate = row.length > 8 ? _parseDate(row[8]) : null;
      project.dprData!.inceptionReportDate = row.length > 9 ? _parseDate(row[9]) : null;
      project.dprData!.surveyDate = row.length > 10 ? _parseDate(row[10]) : null;
      project.dprData!.alignmentLayoutDate = row.length > 11 ? _parseDate(row[11]) : null;
      project.dprData!.draftDPRDate = row.length > 12 ? _parseDate(row[12]) : null;
      project.dprData!.drawingsDate = row.length > 13 ? _parseDate(row[13]) : null;
      project.dprData!.boqDate = row.length > 14 ? _parseDate(row[14]) : null;
      project.dprData!.envClearanceDate = row.length > 15 ? _parseDate(row[15]) : null;
      project.dprData!.cashFlowDate = row.length > 16 ? _parseDate(row[16]) : null;
      project.dprData!.laProposalDate = row.length > 17 ? _parseDate(row[17]) : null;
      project.dprData!.utilityShiftingDate = row.length > 18 ? _parseDate(row[18]) : null;
      project.dprData!.finalDPRDate = row.length > 19 ? _parseDate(row[19]) : null;
      project.dprData!.bidDocWorkDate = row.length > 20 ? _parseDate(row[20]) : null;

      // Determine status from date presence (simplified for CSV without color info)
      project.dprData!.bidDocDPRStatus = row.length > 3 && row[3] != null && row[3].toString().trim().isNotEmpty ? WorkflowStatus.inProgress : WorkflowStatus.notStarted;
      project.dprData!.workOrderStatus = row.length > 8 && row[8] != null && row[8].toString().trim().isNotEmpty ? WorkflowStatus.inProgress : WorkflowStatus.notStarted;
    }
  }

  Future<void> _readWorkSheet(String sheetId, Map<String, Project> projectMap) async {
    print('Attempting to read Work sheet...');

    // Use the correct GID for Work sheet
    final possibleGids = ['1125535582'];

    for (final gid in possibleGids) {
      try {
        print('Trying Work sheet with GID $gid...');
        final csvData = await _fetchSheetAsCSV(sheetId, gid);
        final rows = const CsvToListConverter().convert(csvData);

        print('Work sheet: Fetched ${rows.length} rows');
        if (rows.length > 2) {
          print('Work sheet Row 2: ${rows[2]}');
        }

        // Check if this looks like the Work sheet (headers in row 2: Sr No., Name of Work, AA, DPR, TS...)
        if (rows.length > 2 && rows[2].length > 3) {
          final headers = rows[2].toString().toLowerCase();
          print('Work sheet headers (row 2) lowercase: $headers');
          print('Contains aa: ${headers.contains('aa')}');
          print('Contains bid doc: ${headers.contains('bid doc')}');

          if (headers.contains('aa') && headers.contains('bid doc')) {
            print('Work sheet GID $gid fetched successfully');
            await _processWorkSheet(rows, projectMap);
            return; // Success, exit
          } else {
            print('Work sheet header validation failed');
          }
        } else {
          print('Work sheet has insufficient rows');
        }
      } catch (e) {
        print('Work sheet GID $gid failed with exception: $e');
        continue;
      }
    }

    print('WARNING: Work sheet could not be read with any known GID. All workData will be null.');
  }

  Future<void> _processWorkSheet(List<List<dynamic>> rows, Map<String, Project> projectMap) async {
    print('Work Sheet: Found ${rows.length} rows');

    // Skip row 0 (empty), row 1 (headers), row 2 (responsible persons or category headers)
    for (int rowIndex = 3; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];

      if (row.isEmpty || row[0] == null || row[0].toString().trim().isEmpty) continue;
      if (row[0].toString().length == 1 && RegExp(r'[A-E]').hasMatch(row[0].toString())) continue;

      final projectName = row.length > 1 ? row[1]?.toString().trim() : null;
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategoryFromSheet(rows, rowIndex),
          srNo: rowIndex - 1,
        ),
      );

      project.workData ??= WorkData();

      project.workData!.aa = row.length > 2 ? _parseDate(row[2]) : null;
      project.workData!.dpr = row.length > 3 ? _parseDate(row[3]) : null;
      project.workData!.ts = row.length > 4 ? _parseDate(row[4]) : null;
      project.workData!.bidDoc = row.length > 5 ? _parseDate(row[5]) : null;
      project.workData!.bidInvite = row.length > 6 ? _parseDate(row[6]) : null;
      project.workData!.prebid = row.length > 7 ? _parseDate(row[7]) : null;
      project.workData!.csd = row.length > 8 ? _parseDate(row[8]) : null;
      project.workData!.bidSubmit = row.length > 9 ? _parseDate(row[9]) : null;
      project.workData!.finBid = row.length > 10 ? _parseDate(row[10]) : null;
      project.workData!.loi = row.length > 11 ? _parseDate(row[11]) : null;
      project.workData!.loa = row.length > 12 ? _parseDate(row[12]) : null;
      project.workData!.pbg = row.length > 13 ? _parseDate(row[13]) : null;
      project.workData!.agreement = row.length > 14 ? _parseDate(row[14]) : null;
      project.workData!.workOrder = row.length > 15 ? _parseDate(row[15]) : null;
    }
  }

  Future<void> _readMonitoringSheet(String sheetId, Map<String, Project> projectMap) async {
    print('Attempting to read Monitoring sheet...');

    // Use the correct GID for Monitoring sheet
    final possibleGids = ['658079950'];

    for (final gid in possibleGids) {
      try {
        print('Trying Monitoring sheet with GID $gid...');
        final csvData = await _fetchSheetAsCSV(sheetId, gid);
        final rows = const CsvToListConverter().convert(csvData);

        print('Monitoring sheet: Fetched ${rows.length} rows');
        if (rows.length > 2) {
          print('Monitoring Row 0: ${rows[0]}');
          print('Monitoring Row 1: ${rows[1]}');
          print('Monitoring Row 2: ${rows[2]}');
        }

        // Check if this looks like the Monitoring sheet (headers in row 2: Sr. No., Name of Work, Agmnt Amount...)
        if (rows.length > 2 && rows[2].length > 3) {
          final headers = rows[2].toString().toLowerCase();
          print('Monitoring headers (row 2): $headers');
          if (headers.contains('agmnt') || headers.contains('name of work')) {
            print('Monitoring sheet GID $gid fetched successfully');
            await _processMonitoringSheet(rows, projectMap);
            return; // Success, exit
          } else {
            print('Monitoring header validation failed');
          }
        }
      } catch (e) {
        print('Monitoring sheet GID $gid failed: $e');
        continue;
      }
    }

    print('WARNING: Monitoring sheet could not be read with any known GID. All monitoringData will be null.');
  }

  Future<void> _processMonitoringSheet(List<List<dynamic>> rows, Map<String, Project> projectMap) async {
    print('Monitoring Sheet: Found ${rows.length} rows');

    // Skip row 0 (empty), row 1 (responsible persons), row 2 (headers)
    for (int rowIndex = 3; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];

      if (row.isEmpty || row[0] == null || row[0].toString().trim().isEmpty) continue;
      if (row[0].toString().length == 1 && RegExp(r'[A-E]').hasMatch(row[0].toString())) continue;

      final projectName = row.length > 1 ? row[1]?.toString().trim() : null;
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategoryFromSheet(rows, rowIndex),
          srNo: rowIndex - 1,
        ),
      );

      project.monitoringData ??= MonitoringData();

      project.monitoringData!.agreementAmount = row.length > 2 ? _parseDouble(row[2]) : null;
      project.monitoringData!.appointedDate = row.length > 3 ? _parseDate(row[3]) : null;
      project.monitoringData!.tenderPeriod = row.length > 4 ? row[4]?.toString() : null;
      project.monitoringData!.firstMilestone = row.length > 5 ? _parseInt(row[5]) : null;
      project.monitoringData!.secondMilestone = row.length > 6 ? _parseInt(row[6]) : null;
      project.monitoringData!.thirdMilestone = row.length > 7 ? _parseInt(row[7]) : null;
      project.monitoringData!.fourthMilestone = row.length > 8 ? _parseInt(row[8]) : null;
      project.monitoringData!.fifthMilestone = row.length > 9 ? _parseInt(row[9]) : null;
      project.monitoringData!.ld = row.length > 10 ? row[10]?.toString() : null;
      project.monitoringData!.cos = row.length > 11 ? row[11]?.toString() : null;
      project.monitoringData!.eot = row.length > 12 ? row[12]?.toString() : null;
      project.monitoringData!.cumulativeExpenditure = row.length > 13 ? _parseDouble(row[13]) : null;
      project.monitoringData!.finalBill = row.length > 14 ? _parseDouble(row[14]) : null;
      project.monitoringData!.auditPara = row.length > 15 ? row[15]?.toString() : null;
      project.monitoringData!.replies = row.length > 16 ? row[16]?.toString() : null;
      project.monitoringData!.laqLcq = row.length > 17 ? row[17]?.toString() : null;
      project.monitoringData!.techAudit = row.length > 18 ? row[18]?.toString() : null;
    }
  }

  Future<void> _readWorkEntrySheet(String sheetId, Map<String, Project> projectMap) async {
    print('Attempting to read Work Entry sheet...');

    // Use the correct GID for Work Entry sheet
    final possibleGids = ['709182212'];

    for (final gid in possibleGids) {
      try {
        print('Trying Work Entry sheet with GID $gid...');
        final csvData = await _fetchSheetAsCSV(sheetId, gid);
        final rows = const CsvToListConverter().convert(csvData);

        // Check if this looks like the Work Entry sheet (row 0: Work Id, Name of Work; row 1: DPR, Particulars...)
        if (rows.length > 2 && rows[0].isNotEmpty) {
          final headers0 = rows[0].toString().toLowerCase();
          final headers1 = rows.length > 1 ? rows[1].toString().toLowerCase() : '';
          if (headers0.contains('work id') || headers1.contains('particulars')) {
            print('Work Entry sheet GID $gid fetched successfully');
            await _processWorkEntrySheet(rows, projectMap);
            return; // Success, exit
          }
        }
      } catch (e) {
        print('Work Entry sheet GID $gid failed: $e');
        continue;
      }
    }

    print('WARNING: Work Entry sheet could not be read with any known GID. All workEntryActivities will be null.');
  }

  Future<void> _processWorkEntrySheet(List<List<dynamic>> rows, Map<String, Project> projectMap) async {

    final activitiesByProject = <String, List<WorkEntryActivity>>{};

    for (int rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];

      if (row.length < 3) continue;

      final projectName = row[1]?.toString().trim();
      final particulars = row[2]?.toString();

      if (projectName == null || projectName.isEmpty || particulars == null) continue;

      final activity = WorkEntryActivity(
        particulars: particulars,
        startDate: row.length > 3 ? _parseDate(row[3]) : null,
        periodDays: row.length > 4 ? _parseInt(row[4]) : null,
        endDate: row.length > 5 ? _parseDate(row[5]) : null,
        personResponsible: row.length > 6 ? row[6]?.toString() : null,
        postHeld: row.length > 7 ? row[7]?.toString() : null,
        pendingWith: row.length > 8 ? row[8]?.toString() : null,
      );

      activitiesByProject.putIfAbsent(projectName, () => []).add(activity);
    }

    activitiesByProject.forEach((projectName, activities) {
      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: projectName,
          category: 'Uncategorized',
          srNo: 0,
        ),
      );

      project.workEntryActivities = activities;
    });
  }

  // Fetch sheet as CSV
  Future<String> _fetchSheetAsCSV(String sheetId, String gid) async {
    final isPublished = await _isConnectedSheetPublished();

    String url;
    if (isPublished) {
      // For published sheets, we need to use a different approach
      // The GID parameter doesn't work reliably with published URLs
      // Instead, we'll use the single parameter format
      if (gid == '0') {
        // Default first sheet - use standard published URL
        url = 'https://docs.google.com/spreadsheets/d/e/$sheetId/pub?output=csv';
      } else {
        // For other sheets, try with gid parameter
        url = 'https://docs.google.com/spreadsheets/d/e/$sheetId/pub?gid=$gid&single=true&output=csv';
      }
    } else {
      // Regular export format: https://docs.google.com/spreadsheets/d/{SHEET_ID}/export?format=csv&gid={GID}
      url = 'https://docs.google.com/spreadsheets/d/$sheetId/export?format=csv&gid=$gid';
    }

    final response = await http.get(Uri.parse(url));

    // Check if response is HTML (error page) instead of CSV
    if (response.body.contains('<!DOCTYPE html>') || response.body.contains('<html')) {
      throw Exception(
        'Google Sheet is not accessible. Please:\n'
        '1. Open your Google Sheet\n'
        '2. Go to File → Share → Publish to web\n'
        '3. Select "Entire Document" and "Comma-separated values (.csv)"\n'
        '4. Click "Publish" and confirm\n'
        '5. Try syncing again'
      );
    }

    if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception(
        'Google Sheet is not accessible. Please:\n'
        '1. Open your Google Sheet\n'
        '2. Go to File → Share → Publish to web\n'
        '3. Select "Entire Document" and "Comma-separated values (.csv)"\n'
        '4. Click "Publish" and confirm\n'
        '5. Try syncing again'
      );
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Google Sheet: ${response.statusCode}');
    }

    return response.body;
  }

  // Helper methods
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final str = value.toString().trim();
    if (str.isEmpty || str == '--' || str == '') return null;

    // Try different date formats in order of likelihood

    // 1. Try M/d/yy format (e.g., 11/28/25) - most common in your sheet
    if (str.contains('/') && str.split('/').length == 3) {
      final parts = str.split('/');
      if (parts[2].length == 2) {
        // This is a M/d/yy format
        try {
          final parsed = _altDateFormat.parse(str);
          // DateFormat might interpret 2-digit years correctly, but check
          if (parsed.year < 100) {
            final fullYear = parsed.year + 2000;
            return DateTime(fullYear, parsed.month, parsed.day);
          }
          return parsed;
        } catch (e) {
          // Continue to next format
        }
      }
    }

    // 2. Try dd.MM.yyyy format (e.g., 09.12.2025)
    if (str.contains('.')) {
      try {
        final dotFormat = DateFormat('dd.MM.yyyy');
        return dotFormat.parse(str);
      } catch (e) {
        // Continue to next format
      }
    }

    // 3. Try dd/MM/yyyy format
    try {
      return _dateFormat.parse(str);
    } catch (e) {
      // Continue to next format
    }

    // 4. Try Excel serial number
    try {
      final dateNum = double.tryParse(str);
      if (dateNum != null && dateNum > 0 && dateNum < 100000) {
        final baseDate = DateTime(1899, 12, 30);
        return baseDate.add(Duration(days: dateNum.toInt()));
      }
    } catch (e) {
      // Continue
    }

    print('Failed to parse date: $str');
    return null;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str == '--') return null;
    return double.tryParse(str);
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str == '--') return null;
    return int.tryParse(str);
  }

  String _getCategoryFromSheet(List<List<dynamic>> rows, int currentRow) {
    for (int i = currentRow - 1; i >= 0; i--) {
      if (rows[i].isNotEmpty) {
        final cell = rows[i][0]?.toString();
        if (cell != null && cell.length == 1 && RegExp(r'[A-E]').hasMatch(cell)) {
          return cell; // Return the category key (A, B, C, D, E)
        }
      }
    }
    return 'Uncategorized';
  }
}
