import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class DPRScreen extends StatefulWidget {
  final Project project;

  const DPRScreen({super.key, required this.project});

  @override
  State<DPRScreen> createState() => _DPRScreenState();
}

class _DPRScreenState extends State<DPRScreen> {
  late DPRData _dprData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool _isEditing = false;
  final TextEditingController _broadScopeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dprData = widget.project.dprData ?? DPRData();
    _broadScopeController.text = _dprData.broadScope ?? '';
  }

  @override
  void dispose() {
    _broadScopeController.dispose();
    super.dispose();
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
      case 'bidDocDPR':
        return _dprData.bidDocDPR;
      case 'tenderInvite':
        return _dprData.tenderInvite;
      case 'prebid':
        return _dprData.prebid;
      case 'csd':
        return _dprData.csd;
      case 'bidSubmit':
        return _dprData.bidSubmit;
      case 'workOrder':
        return _dprData.workOrder;
      case 'inceptionReport':
        return _dprData.inceptionReport;
      case 'survey':
        return _dprData.survey;
      case 'alignmentLayout':
        return _dprData.alignmentLayout;
      case 'draftDPR':
        return _dprData.draftDPR;
      case 'drawings':
        return _dprData.drawings;
      case 'boq':
        return _dprData.boq;
      case 'envClearance':
        return _dprData.envClearance;
      case 'cashFlow':
        return _dprData.cashFlow;
      case 'laProposal':
        return _dprData.laProposal;
      case 'utilityShifting':
        return _dprData.utilityShifting;
      case 'finalDPR':
        return _dprData.finalDPR;
      case 'bidDocWork':
        return _dprData.bidDocWork;
      default:
        return null;
    }
  }

  void _setDateForField(String field, DateTime date) {
    switch (field) {
      case 'bidDocDPR':
        _dprData.bidDocDPR = date;
        break;
      case 'tenderInvite':
        _dprData.tenderInvite = date;
        break;
      case 'prebid':
        _dprData.prebid = date;
        break;
      case 'csd':
        _dprData.csd = date;
        break;
      case 'bidSubmit':
        _dprData.bidSubmit = date;
        break;
      case 'workOrder':
        _dprData.workOrder = date;
        break;
      case 'inceptionReport':
        _dprData.inceptionReport = date;
        break;
      case 'survey':
        _dprData.survey = date;
        break;
      case 'alignmentLayout':
        _dprData.alignmentLayout = date;
        break;
      case 'draftDPR':
        _dprData.draftDPR = date;
        break;
      case 'drawings':
        _dprData.drawings = date;
        break;
      case 'boq':
        _dprData.boq = date;
        break;
      case 'envClearance':
        _dprData.envClearance = date;
        break;
      case 'cashFlow':
        _dprData.cashFlow = date;
        break;
      case 'laProposal':
        _dprData.laProposal = date;
        break;
      case 'utilityShifting':
        _dprData.utilityShifting = date;
        break;
      case 'finalDPR':
        _dprData.finalDPR = date;
        break;
      case 'bidDocWork':
        _dprData.bidDocWork = date;
        break;
    }
  }

  void _saveChanges() {
    _dprData.broadScope = _broadScopeController.text.isNotEmpty ? _broadScopeController.text : null;
    widget.project.dprData = _dprData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('DPR data saved successfully'),
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
              const Icon(Icons.description, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Detailed Project Report (DPR)',
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
                      _dprData = widget.project.dprData ?? DPRData();
                      _broadScopeController.text = _dprData.broadScope ?? '';
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
            itemCount: AppConstants.dprFields.length,
            itemBuilder: (context, index) {
              final fieldInfo = AppConstants.dprFields[index];
              final fieldName = _getFieldNameFromIndex(index);

              // Special handling for Broad Scope field
              if (fieldName == 'broadScope') {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Broad Scope of Work',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Responsible: Engineering',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textHint,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: _broadScopeController,
                            enabled: _isEditing,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: 'Enter broad scope of work...',
                              filled: true,
                              fillColor: _isEditing ? Colors.white : Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return _buildDateField(fieldName, fieldInfo);
            },
          ),
        ),
      ],
    );
  }

  String _getFieldNameFromIndex(int index) {
    const fieldNames = [
      'broadScope',
      'bidDocDPR',
      'tenderInvite',
      'prebid',
      'csd',
      'bidSubmit',
      'workOrder',
      'inceptionReport',
      'survey',
      'alignmentLayout',
      'draftDPR',
      'drawings',
      'boq',
      'envClearance',
      'cashFlow',
      'laProposal',
      'utilityShifting',
      'finalDPR',
      'bidDocWork',
    ];
    return fieldNames[index];
  }
}
