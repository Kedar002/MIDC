import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/work_data.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class WorkScreen extends StatefulWidget {
  final Project project;
  final String searchQuery;

  const WorkScreen({super.key, required this.project, this.searchQuery = ''});

  @override
  State<WorkScreen> createState() => WorkScreenState();
}

class WorkScreenState extends State<WorkScreen> {
  late WorkData workData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    workData = widget.project.workData ?? WorkData();
  }

  Future<void> _selectDate(BuildContext context, String fieldName) async {
    final initialDate = _getDateForField(fieldName) ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _setDateForField(fieldName, pickedDate);
      });
    }
  }

  DateTime? _getDateForField(String field) {
    switch (field) {
      case 'aa':
        return workData.aa;
      case 'dpr':
        return workData.dpr;
      case 'ts':
        return workData.ts;
      case 'bidDoc':
        return workData.bidDoc;
      case 'bidInvite':
        return workData.bidInvite;
      case 'prebid':
        return workData.prebid;
      case 'csd':
        return workData.csd;
      case 'bidSubmit':
        return workData.bidSubmit;
      case 'finBid':
        return workData.finBid;
      case 'loi':
        return workData.loi;
      case 'loa':
        return workData.loa;
      case 'pbg':
        return workData.pbg;
      case 'agreement':
        return workData.agreement;
      case 'workOrder':
        return workData.workOrder;
      default:
        return null;
    }
  }

  void _setDateForField(String field, DateTime date) {
    switch (field) {
      case 'aa':
        workData.aa = date;
        break;
      case 'dpr':
        workData.dpr = date;
        break;
      case 'ts':
        workData.ts = date;
        break;
      case 'bidDoc':
        workData.bidDoc = date;
        break;
      case 'bidInvite':
        workData.bidInvite = date;
        break;
      case 'prebid':
        workData.prebid = date;
        break;
      case 'csd':
        workData.csd = date;
        break;
      case 'bidSubmit':
        workData.bidSubmit = date;
        break;
      case 'finBid':
        workData.finBid = date;
        break;
      case 'loi':
        workData.loi = date;
        break;
      case 'loa':
        workData.loa = date;
        break;
      case 'pbg':
        workData.pbg = date;
        break;
      case 'agreement':
        workData.agreement = date;
        break;
      case 'workOrder':
        workData.workOrder = date;
        break;
    }
  }

  void saveChanges() {
    widget.project.workData = workData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully'),
        backgroundColor: AppTheme.statusCompleted,
      ),
    );
  }

  Widget _buildDateField(String fieldName, Map<String, String> fieldInfo) {
    final date = _getDateForField(fieldName);
    final dateString = date != null ? _dateFormat.format(date) : 'Not set';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    fieldInfo['label']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    onPressed: () => _selectDate(context, fieldName),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Responsible: ${fieldInfo['responsiblePerson']}',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: date != null
                    ? AppTheme.statusCompleted.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: date != null
                      ? AppTheme.statusCompleted.withOpacity(0.3)
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    date != null ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: date != null ? AppTheme.statusCompleted : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateString,
                    style: TextStyle(
                      fontSize: 13,
                      color: date != null ? AppTheme.textPrimary : AppTheme.textHint,
                      fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (fieldInfo['fullName'] != null && fieldInfo['fullName'] != fieldInfo['label']) ...[
              const SizedBox(height: 4),
              Text(
                fieldInfo['fullName']!,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textHint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(Map<String, String> fieldInfo) {
    if (widget.searchQuery.isEmpty) return true;
    final query = widget.searchQuery.toLowerCase();
    return fieldInfo['label']!.toLowerCase().contains(query) ||
        (fieldInfo['responsiblePerson']?.toLowerCase().contains(query) ?? false) ||
        (fieldInfo['fullName']?.toLowerCase().contains(query) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredFields = <int>[];
    for (int i = 0; i < AppConstants.workFields.length; i++) {
      if (_matchesSearch(AppConstants.workFields[i])) {
        filteredFields.add(i);
      }
    }

    if (filteredFields.isEmpty && widget.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No results found for "${widget.searchQuery}"',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 140,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredFields.length,
      itemBuilder: (context, idx) {
        final index = filteredFields[idx];
        final fieldInfo = AppConstants.workFields[index];
        final fieldName = _getFieldNameFromIndex(index);
        return _buildDateField(fieldName, fieldInfo);
      },
    );
  }

  String _getFieldNameFromIndex(int index) {
    const fieldNames = [
      'aa',
      'dpr',
      'ts',
      'bidDoc',
      'bidInvite',
      'prebid',
      'csd',
      'bidSubmit',
      'finBid',
      'loi',
      'loa',
      'pbg',
      'agreement',
      'workOrder'
    ];
    return fieldNames[index];
  }
}
