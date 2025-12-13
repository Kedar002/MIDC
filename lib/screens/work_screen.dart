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

  const WorkScreen({super.key, required this.project});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late WorkData _workData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _workData = widget.project.workData ?? WorkData();
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
        return _workData.aa;
      case 'dpr':
        return _workData.dpr;
      case 'ts':
        return _workData.ts;
      case 'bidDoc':
        return _workData.bidDoc;
      case 'bidInvite':
        return _workData.bidInvite;
      case 'prebid':
        return _workData.prebid;
      case 'csd':
        return _workData.csd;
      case 'bidSubmit':
        return _workData.bidSubmit;
      case 'finBid':
        return _workData.finBid;
      case 'loi':
        return _workData.loi;
      case 'loa':
        return _workData.loa;
      case 'pbg':
        return _workData.pbg;
      case 'agreement':
        return _workData.agreement;
      case 'workOrder':
        return _workData.workOrder;
      default:
        return null;
    }
  }

  void _setDateForField(String field, DateTime date) {
    switch (field) {
      case 'aa':
        _workData.aa = date;
        break;
      case 'dpr':
        _workData.dpr = date;
        break;
      case 'ts':
        _workData.ts = date;
        break;
      case 'bidDoc':
        _workData.bidDoc = date;
        break;
      case 'bidInvite':
        _workData.bidInvite = date;
        break;
      case 'prebid':
        _workData.prebid = date;
        break;
      case 'csd':
        _workData.csd = date;
        break;
      case 'bidSubmit':
        _workData.bidSubmit = date;
        break;
      case 'finBid':
        _workData.finBid = date;
        break;
      case 'loi':
        _workData.loi = date;
        break;
      case 'loa':
        _workData.loa = date;
        break;
      case 'pbg':
        _workData.pbg = date;
        break;
      case 'agreement':
        _workData.agreement = date;
        break;
      case 'workOrder':
        _workData.workOrder = date;
        break;
    }
  }

  void _saveChanges() {
    widget.project.workData = _workData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      _isEditing = false;
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
                if (_isEditing)
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.work, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Work Process',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (!_isEditing)
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              if (_isEditing) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _workData = widget.project.workData ?? WorkData();
                      _isEditing = false;
                    });
                  },
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Save'),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 140,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: AppConstants.workFields.length,
            itemBuilder: (context, index) {
              final fieldInfo = AppConstants.workFields[index];
              final fieldName = _getFieldNameFromIndex(index);
              return _buildDateField(fieldName, fieldInfo);
            },
          ),
        ),
      ],
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
