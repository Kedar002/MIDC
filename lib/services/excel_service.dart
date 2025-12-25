import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../models/work_data.dart';
import '../models/monitoring_data.dart';
import '../models/work_entry_data.dart';
import '../utils/constants.dart';

class ExcelService {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _altDateFormat = DateFormat('M/d/yy');

  // Import Excel file and return list of projects
  Future<List<Project>> importExcel() async {
    try {
      // Pick Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null || result.files.single.path == null) {
        throw Exception('No file selected');
      }

      final bytes = File(result.files.single.path!).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final projects = <Project>[];
      final projectMap = <String, Project>{};

      // Process each sheet
      for (var sheetName in excel.tables.keys) {
        final sheet = excel.tables[sheetName]!;

        if (sheetName == 'DPR') {
          _processDPRSheet(sheet, projectMap);
        } else if (sheetName == 'Work') {
          _processWorkSheet(sheet, projectMap);
        } else if (sheetName == 'Monitoring') {
          _processMonitoringSheet(sheet, projectMap);
        } else if (sheetName == 'Work Entry') {
          _processWorkEntrySheet(sheet, projectMap);
        }
      }

      projects.addAll(projectMap.values);
      return projects;
    } catch (e) {
      throw Exception('Failed to import Excel: $e');
    }
  }

  void _processDPRSheet(Sheet sheet, Map<String, Project> projectMap) {
    // Skip header rows (0-1)
    for (int rowIndex = 2; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.rows[rowIndex];

      // Skip category headers (single letters)
      final firstCell = row[0]?.value;
      if (firstCell == null || firstCell.toString().trim().isEmpty) continue;
      if (firstCell.toString().length == 1 && RegExp(r'[A-Z]').hasMatch(firstCell.toString())) continue;

      final projectName = row[1]?.value?.toString().trim();
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategory(rowIndex, sheet),
          srNo: rowIndex,
        ),
      );

      // Initialize DPR data
      project.dprData ??= DPRData();

      // Map columns to DPR fields
      project.dprData!.broadScope = row[2]?.value?.toString();

      // Column 3: Bid Doc DPR
      project.dprData!.bidDocDPRDate = _parseDate(row[3]);
      project.dprData!.bidDocDPRStatus = _getStatusFromCell(row[3]);

      // Column 4: Tender Invite
      project.dprData!.tenderInviteDate = _parseDate(row[4]);

      // Column 5: Prebid
      project.dprData!.prebidDate = _parseDate(row[5]);
      project.dprData!.prebidStatus = _getStatusFromCell(row[5]);

      // Column 6: CSD
      project.dprData!.csdDate = _parseDate(row[6]);

      // Column 7: Bid Submit
      project.dprData!.bidSubmitDate = _parseDate(row[7]);

      // Column 8: Work Order
      project.dprData!.workOrderDate = _parseDate(row[8]);
      project.dprData!.workOrderStatus = _getStatusFromCell(row[8]);

      // Column 9: Inception Report
      project.dprData!.inceptionReportDate = _parseDate(row[9]);
      project.dprData!.inceptionReportStatus = _getStatusFromCell(row[9]);

      // Column 10: Survey
      project.dprData!.surveyDate = _parseDate(row[10]);
      project.dprData!.surveyStatus = _getStatusFromCell(row[10]);

      // Column 11: Alignment/Layout
      project.dprData!.alignmentLayoutDate = _parseDate(row[11]);
      project.dprData!.alignmentLayoutStatus = _getStatusFromCell(row[11]);

      // Column 12: Draft DPR
      project.dprData!.draftDPRDate = _parseDate(row[12]);
      project.dprData!.draftDPRStatus = _getStatusFromCell(row[12]);

      // Column 13: Drawings
      project.dprData!.drawingsDate = _parseDate(row[13]);
      project.dprData!.drawingsStatus = _getStatusFromCell(row[13]);

      // Column 14: BOQ
      project.dprData!.boqDate = _parseDate(row[14]);
      project.dprData!.boqStatus = _getStatusFromCell(row[14]);

      // Column 15: Env Clearance
      project.dprData!.envClearanceDate = _parseDate(row[15]);
      project.dprData!.envClearanceStatus = _getStatusFromCell(row[15]);

      // Column 16: Cash-Flow
      project.dprData!.cashFlowDate = _parseDate(row[16]);
      project.dprData!.cashFlowStatus = _getStatusFromCell(row[16]);

      // Column 17: LA Proposal
      project.dprData!.laProposalDate = _parseDate(row[17]);
      project.dprData!.laProposalStatus = _getStatusFromCell(row[17]);

      // Column 18: Utility Shifting
      project.dprData!.utilityShiftingDate = _parseDate(row[18]);
      project.dprData!.utilityShiftingStatus = _getStatusFromCell(row[18]);

      // Column 19: Final DPR
      project.dprData!.finalDPRDate = _parseDate(row[19]);
      project.dprData!.finalDPRStatus = _getStatusFromCell(row[19]);

      // Column 20: Bid Doc Work
      project.dprData!.bidDocWorkDate = _parseDate(row[20]);
      project.dprData!.bidDocWorkStatus = _getStatusFromCell(row[20]);
    }
  }

  void _processWorkSheet(Sheet sheet, Map<String, Project> projectMap) {
    // Skip header rows
    for (int rowIndex = 2; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.rows[rowIndex];

      final firstCell = row[0]?.value;
      if (firstCell == null || firstCell.toString().trim().isEmpty) continue;
      if (firstCell.toString().length == 1 && RegExp(r'[A-Z]').hasMatch(firstCell.toString())) continue;

      final projectName = row[1]?.value?.toString().trim();
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategory(rowIndex, sheet),
          srNo: rowIndex,
        ),
      );

      project.workData ??= WorkData();

      // Map Work sheet columns (columns 2-15)
      project.workData!.aa = _parseDate(row[2]);
      project.workData!.dpr = _parseDate(row[3]);
      project.workData!.ts = _parseDate(row[4]);
      project.workData!.bidDoc = _parseDate(row[5]);
      project.workData!.bidInvite = _parseDate(row[6]);
      project.workData!.prebid = _parseDate(row[7]);
      project.workData!.csd = _parseDate(row[8]);
      project.workData!.bidSubmit = _parseDate(row[9]);
      project.workData!.finBid = _parseDate(row[10]);
      project.workData!.loi = _parseDate(row[11]);
      project.workData!.loa = _parseDate(row[12]);
      project.workData!.pbg = _parseDate(row[13]);
      project.workData!.agreement = _parseDate(row[14]);
      project.workData!.workOrder = _parseDate(row[15]);
    }
  }

  void _processMonitoringSheet(Sheet sheet, Map<String, Project> projectMap) {
    // Skip header rows
    for (int rowIndex = 2; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.rows[rowIndex];

      final firstCell = row[0]?.value;
      if (firstCell == null || firstCell.toString().trim().isEmpty) continue;
      if (firstCell.toString().length == 1 && RegExp(r'[A-Z]').hasMatch(firstCell.toString())) continue;

      final projectName = row[1]?.value?.toString().trim();
      if (projectName == null || projectName.isEmpty) continue;

      final project = projectMap.putIfAbsent(
        projectName,
        () => Project(
          id: DateTime.now().millisecondsSinceEpoch.toString() + rowIndex.toString(),
          name: projectName,
          category: _getCategory(rowIndex, sheet),
          srNo: rowIndex,
        ),
      );

      project.monitoringData ??= MonitoringData();

      // Map Monitoring sheet columns
      project.monitoringData!.agreementAmount = _parseDouble(row[2]);
      project.monitoringData!.appointedDate = _parseDate(row[3]);
      project.monitoringData!.tenderPeriod = row[4]?.value?.toString();
      project.monitoringData!.firstMilestone = _parseInt(row[5]);
      project.monitoringData!.secondMilestone = _parseInt(row[6]);
      project.monitoringData!.thirdMilestone = _parseInt(row[7]);
      project.monitoringData!.fourthMilestone = _parseInt(row[8]);
      project.monitoringData!.fifthMilestone = _parseInt(row[9]);
      project.monitoringData!.ld = row[10]?.value?.toString();
      project.monitoringData!.cos = row[11]?.value?.toString();
      project.monitoringData!.eot = row[12]?.value?.toString();
      project.monitoringData!.cumulativeExpenditure = _parseDouble(row[13]);
      project.monitoringData!.finalBill = _parseDouble(row[14]);
      project.monitoringData!.auditPara = row[15]?.value?.toString();
      project.monitoringData!.replies = row[16]?.value?.toString();
      project.monitoringData!.laqLcq = row[17]?.value?.toString();
      project.monitoringData!.techAudit = row[18]?.value?.toString();
    }
  }

  void _processWorkEntrySheet(Sheet sheet, Map<String, Project> projectMap) {
    // Work Entry has different structure - each row is an activity
    // Group by Work Id / Name of Work
    final activitiesByProject = <String, List<WorkEntryActivity>>{};

    for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.rows[rowIndex];

      final workId = row[0]?.value?.toString();
      final projectName = row[1]?.value?.toString().trim();
      final particulars = row[2]?.value?.toString();

      if (projectName == null || projectName.isEmpty || particulars == null) continue;

      final activity = WorkEntryActivity(
        particulars: particulars,
        startDate: _parseDate(row[3]),
        periodDays: _parseInt(row[4]),
        endDate: _parseDate(row[5]),
        personResponsible: row[6]?.value?.toString(),
        postHeld: row[7]?.value?.toString(),
        pendingWith: row[8]?.value?.toString(),
      );

      activitiesByProject.putIfAbsent(projectName, () => []).add(activity);
    }

    // Assign activities to projects
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

  DateTime? _parseDate(Data? cell) {
    if (cell == null || cell.value == null) return null;

    final value = cell.value.toString().trim();
    if (value.isEmpty || value == '--') return null;

    try {
      // Try multiple date formats
      return _dateFormat.parse(value);
    } catch (e) {
      try {
        return _altDateFormat.parse(value);
      } catch (e) {
        // Try Excel date number format
        try {
          final dateNum = double.tryParse(value);
          if (dateNum != null) {
            // Excel dates are days since 1900-01-01
            final baseDate = DateTime(1899, 12, 30);
            return baseDate.add(Duration(days: dateNum.toInt()));
          }
        } catch (e) {
          return null;
        }
        return null;
      }
    }
  }

  WorkflowStatus? _getStatusFromCell(Data? cell) {
    if (cell == null || cell.value == null) return WorkflowStatus.notStarted;

    final cellStyle = cell.cellStyle;
    if (cellStyle == null) return WorkflowStatus.notStarted;

    // Check background color using backgroundColor property
    final bgColor = cellStyle.backgroundColor;
    if (bgColor != null) {
      final colorHex = bgColor.colorHex;
      // Green background = Completed
      if (colorHex.toLowerCase().contains('4ea72e') || colorHex.toLowerCase().contains('00ff00')) {
        return WorkflowStatus.completed;
      }
      // Yellow background = In Progress
      if (colorHex.toLowerCase().contains('ffc000') || colorHex.toLowerCase().contains('ffff00')) {
        return WorkflowStatus.inProgress;
      }
    }

    // If there's a date, consider it in progress
    if (cell.value != null && cell.value.toString().trim().isNotEmpty && cell.value.toString() != '--') {
      return WorkflowStatus.inProgress;
    }

    return WorkflowStatus.notStarted;
  }

  double? _parseDouble(Data? cell) {
    if (cell == null || cell.value == null) return null;
    final value = cell.value.toString().trim();
    if (value.isEmpty || value == '--') return null;
    return double.tryParse(value);
  }

  int? _parseInt(Data? cell) {
    if (cell == null || cell.value == null) return null;
    final value = cell.value.toString().trim();
    if (value.isEmpty || value == '--') return null;
    return int.tryParse(value);
  }

  String _getCategory(int rowIndex, Sheet sheet) {
    // Find the last category header (any single letter) before this row
    for (int i = rowIndex - 1; i >= 0; i--) {
      final cell = sheet.rows[i][0]?.value?.toString();
      if (cell != null && cell.length == 1 && RegExp(r'[A-Z]').hasMatch(cell)) {
        return cell; // Return the category key
      }
    }
    return 'Uncategorized';
  }

  // Export projects to Excel
  Future<String> exportExcel(List<Project> projects, {Map<String, dynamic>? customCategories}) async {
    final excel = Excel.createExcel();

    // Remove default sheet
    excel.delete('Sheet1');

    // Create sheets with custom categories
    _createDPRSheet(excel, projects, customCategories);
    _createWorkSheet(excel, projects, customCategories);
    _createMonitoringSheet(excel, projects, customCategories);
    _createWorkEntrySheet(excel, projects);

    // Save file
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'MSIDC_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    return filePath;
  }

  void _createDPRSheet(Excel excel, List<Project> projects, Map<String, dynamic>? customCategories) {
    final sheet = excel['DPR'];
    // Merge default categories with custom category names
    final customCategoryNames = customCategories?.map((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('name')) {
        return MapEntry(key, value['name'] as String);
      } else if (value is String) {
        return MapEntry(key, value);
      }
      return MapEntry(key, 'Unknown');
    }) ?? {};
    final allCategories = {...AppConstants.categories, ...customCategoryNames};

    // Header row 1 - Column names
    final headers = [
      'Sr. No.', 'Name of Work', 'Broad Scope of Work', 'Bid Doc DPR', 'Invite',
      'Prebid', 'CSD', 'Bid Submit', 'Work Order', 'Inception Report', 'Survey',
      'Alignment / Layout', 'Draft DPR', 'Drawings', 'BOQ', 'Env Clearance',
      'Cash-Flow', 'LA Proposal', 'Utility Shifting', 'Final DPR', 'Bid Doc Work'
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(bold: true);
    }

    // Data rows
    int rowIndex = 1;
    final groupedProjects = _groupByCategory(projects);

    groupedProjects.forEach((category, categoryProjects) {
      // Category header
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        ..value = TextCellValue(_getCategoryLetter(category))
        ..cellStyle = CellStyle(bold: true);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        ..value = TextCellValue(allCategories[category] ?? category)
        ..cellStyle = CellStyle(bold: true);
      rowIndex++;

      // Project rows
      for (final project in categoryProjects) {
        final dpr = project.dprData;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = IntCellValue(rowIndex);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(project.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = TextCellValue(dpr?.broadScope ?? '');

        // Set dates and colors
        _setCellWithColor(sheet, 3, rowIndex, dpr?.bidDocDPRDate, dpr?.bidDocDPRStatus);
        _setCellWithColor(sheet, 4, rowIndex, dpr?.tenderInviteDate, null);
        _setCellWithColor(sheet, 5, rowIndex, dpr?.prebidDate, dpr?.prebidStatus);
        _setCellWithColor(sheet, 6, rowIndex, dpr?.csdDate, null);
        _setCellWithColor(sheet, 7, rowIndex, dpr?.bidSubmitDate, null);
        _setCellWithColor(sheet, 8, rowIndex, dpr?.workOrderDate, dpr?.workOrderStatus);
        _setCellWithColor(sheet, 9, rowIndex, dpr?.inceptionReportDate, dpr?.inceptionReportStatus);
        _setCellWithColor(sheet, 10, rowIndex, dpr?.surveyDate, dpr?.surveyStatus);
        _setCellWithColor(sheet, 11, rowIndex, dpr?.alignmentLayoutDate, dpr?.alignmentLayoutStatus);
        _setCellWithColor(sheet, 12, rowIndex, dpr?.draftDPRDate, dpr?.draftDPRStatus);
        _setCellWithColor(sheet, 13, rowIndex, dpr?.drawingsDate, dpr?.drawingsStatus);
        _setCellWithColor(sheet, 14, rowIndex, dpr?.boqDate, dpr?.boqStatus);
        _setCellWithColor(sheet, 15, rowIndex, dpr?.envClearanceDate, dpr?.envClearanceStatus);
        _setCellWithColor(sheet, 16, rowIndex, dpr?.cashFlowDate, dpr?.cashFlowStatus);
        _setCellWithColor(sheet, 17, rowIndex, dpr?.laProposalDate, dpr?.laProposalStatus);
        _setCellWithColor(sheet, 18, rowIndex, dpr?.utilityShiftingDate, dpr?.utilityShiftingStatus);
        _setCellWithColor(sheet, 19, rowIndex, dpr?.finalDPRDate, dpr?.finalDPRStatus);
        _setCellWithColor(sheet, 20, rowIndex, dpr?.bidDocWorkDate, dpr?.bidDocWorkStatus);

        rowIndex++;
      }
    });
  }

  void _createWorkSheet(Excel excel, List<Project> projects, Map<String, dynamic>? customCategories) {
    final sheet = excel['Work'];
    // Merge default categories with custom category names
    final customCategoryNames = customCategories?.map((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('name')) {
        return MapEntry(key, value['name'] as String);
      } else if (value is String) {
        return MapEntry(key, value);
      }
      return MapEntry(key, 'Unknown');
    }) ?? {};
    final allCategories = {...AppConstants.categories, ...customCategoryNames};

    final headers = [
      'Sr No.', 'Name of Work', 'AA', 'DPR', 'TS', 'Bid Doc', 'Bid Invite',
      'Prebid', 'CSD', 'Bid Submit', 'Fin Bid', 'LOI', 'LOA', 'PBG', 'Agreement', 'Work Order'
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(bold: true);
    }

    int rowIndex = 1;
    final groupedProjects = _groupByCategory(projects);

    groupedProjects.forEach((category, categoryProjects) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        ..value = TextCellValue(_getCategoryLetter(category))
        ..cellStyle = CellStyle(bold: true);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        ..value = TextCellValue(allCategories[category] ?? category)
        ..cellStyle = CellStyle(bold: true);
      rowIndex++;

      for (final project in categoryProjects) {
        final work = project.workData;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = IntCellValue(rowIndex);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(project.name);

        _setCellDate(sheet, 2, rowIndex, work?.aa);
        _setCellDate(sheet, 3, rowIndex, work?.dpr);
        _setCellDate(sheet, 4, rowIndex, work?.ts);
        _setCellDate(sheet, 5, rowIndex, work?.bidDoc);
        _setCellDate(sheet, 6, rowIndex, work?.bidInvite);
        _setCellDate(sheet, 7, rowIndex, work?.prebid);
        _setCellDate(sheet, 8, rowIndex, work?.csd);
        _setCellDate(sheet, 9, rowIndex, work?.bidSubmit);
        _setCellDate(sheet, 10, rowIndex, work?.finBid);
        _setCellDate(sheet, 11, rowIndex, work?.loi);
        _setCellDate(sheet, 12, rowIndex, work?.loa);
        _setCellDate(sheet, 13, rowIndex, work?.pbg);
        _setCellDate(sheet, 14, rowIndex, work?.agreement);
        _setCellDate(sheet, 15, rowIndex, work?.workOrder);

        rowIndex++;
      }
    });
  }

  void _createMonitoringSheet(Excel excel, List<Project> projects, Map<String, dynamic>? customCategories) {
    final sheet = excel['Monitoring'];
    // Merge default categories with custom category names
    final customCategoryNames = customCategories?.map((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('name')) {
        return MapEntry(key, value['name'] as String);
      } else if (value is String) {
        return MapEntry(key, value);
      }
      return MapEntry(key, 'Unknown');
    }) ?? {};
    final allCategories = {...AppConstants.categories, ...customCategoryNames};

    final headers = [
      'Sr. No.', 'Name of Work', 'Agmnt Amount Rs. Crore', 'Appointed Date',
      'Tender Period', 'First Milestone', 'Second Milestone', 'Third Milestone',
      'Fourth Milestone', 'Fifth Milestone', 'LD', 'COS', 'EOT', 'Cum Exp',
      'Final Bill', 'Audit Para', 'Replies', 'LAQ/ LCQ', 'Tech Audit'
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(bold: true);
    }

    int rowIndex = 1;
    final groupedProjects = _groupByCategory(projects);

    groupedProjects.forEach((category, categoryProjects) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        ..value = TextCellValue(_getCategoryLetter(category))
        ..cellStyle = CellStyle(bold: true);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        ..value = TextCellValue(allCategories[category] ?? category)
        ..cellStyle = CellStyle(bold: true);
      rowIndex++;

      for (final project in categoryProjects) {
        final monitoring = project.monitoringData;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = IntCellValue(rowIndex);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(project.name);

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value =
          monitoring?.agreementAmount != null ? DoubleCellValue(monitoring!.agreementAmount!) : TextCellValue('--');
        _setCellDate(sheet, 3, rowIndex, monitoring?.appointedDate);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.tenderPeriod ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).value =
          monitoring?.firstMilestone != null ? IntCellValue(monitoring!.firstMilestone!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value =
          monitoring?.secondMilestone != null ? IntCellValue(monitoring!.secondMilestone!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value =
          monitoring?.thirdMilestone != null ? IntCellValue(monitoring!.thirdMilestone!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex)).value =
          monitoring?.fourthMilestone != null ? IntCellValue(monitoring!.fourthMilestone!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex)).value =
          monitoring?.fifthMilestone != null ? IntCellValue(monitoring!.fifthMilestone!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.ld ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.cos ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.eot ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex)).value =
          monitoring?.cumulativeExpenditure != null ? DoubleCellValue(monitoring!.cumulativeExpenditure!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex)).value =
          monitoring?.finalBill != null ? DoubleCellValue(monitoring!.finalBill!) : TextCellValue('--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.auditPara ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.replies ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.laqLcq ?? '--');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: rowIndex)).value =
          TextCellValue(monitoring?.techAudit ?? '--');

        rowIndex++;
      }
    });
  }

  void _createWorkEntrySheet(Excel excel, List<Project> projects) {
    final sheet = excel['Work Entry'];

    final headers = [
      'Work Id', 'Name of Work', 'Particulars', 'Start Date', 'Period',
      'End Date', 'Person Responsible', 'Post Held', 'Pending with whom'
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(bold: true);
    }

    int rowIndex = 1;

    for (final project in projects) {
      if (project.workEntryActivities != null && project.workEntryActivities!.isNotEmpty) {
        for (final activity in project.workEntryActivities!) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(project.id);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(project.name);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = TextCellValue(activity.particulars);
          _setCellDate(sheet, 3, rowIndex, activity.startDate);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value =
            activity.periodDays != null ? IntCellValue(activity.periodDays!) : TextCellValue('--');
          _setCellDate(sheet, 5, rowIndex, activity.endDate);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value =
            TextCellValue(activity.personResponsible ?? '--');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value =
            TextCellValue(activity.postHeld ?? '--');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex)).value =
            TextCellValue(activity.pendingWith ?? '--');

          rowIndex++;
        }
      }
    }
  }

  void _setCellWithColor(Sheet sheet, int col, int row, DateTime? date, WorkflowStatus? status) {
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));

    if (date != null) {
      cell.value = TextCellValue(_dateFormat.format(date));
    } else {
      cell.value = TextCellValue('--');
    }

    // Set background color based on status
    if (status == WorkflowStatus.completed || status == WorkflowStatus.approved) {
      cell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#4EA72E'));
    } else if (status == WorkflowStatus.inProgress) {
      cell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#FFC000'));
    }
  }

  void _setCellDate(Sheet sheet, int col, int row, DateTime? date) {
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));

    if (date != null) {
      cell.value = TextCellValue(_dateFormat.format(date));
    } else {
      cell.value = TextCellValue('--');
    }
  }

  Map<String, List<Project>> _groupByCategory(List<Project> projects) {
    final grouped = <String, List<Project>>{};

    for (final project in projects) {
      grouped.putIfAbsent(project.category, () => []).add(project);
    }

    return grouped;
  }

  String _getCategoryLetter(String category) {
    // If category is already a single letter, return it (supports custom categories)
    if (category.length == 1 && RegExp(r'[A-Z]').hasMatch(category)) {
      return category;
    }
    // For backward compatibility with full names
    switch (category) {
      case 'Nashik Kumbhmela':
        return 'A';
      case 'HAM Projects':
        return 'B';
      case 'Nagpur Works':
        return 'C';
      case 'NHAI Projects':
        return 'D';
      case 'Other Projects':
        return 'E';
      default:
        return category.isNotEmpty ? category[0].toUpperCase() : 'X';
    }
  }
}
