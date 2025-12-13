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
  final String searchQuery;

  const DPRScreen({super.key, required this.project, this.searchQuery = ''});

  @override
  State<DPRScreen> createState() => DPRScreenState();
}

class DPRScreenState extends State<DPRScreen> {
  late DPRData dprData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool isEditing = false;
  final TextEditingController broadScopeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dprData = widget.project.dprData ?? DPRData();
    broadScopeController.text = dprData.broadScope ?? '';
  }

  @override
  void dispose() {
    broadScopeController.dispose();
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
        return dprData.bidDocDPR;
      case 'tenderInvite':
        return dprData.tenderInvite;
      case 'prebid':
        return dprData.prebid;
      case 'csd':
        return dprData.csd;
      case 'bidSubmit':
        return dprData.bidSubmit;
      case 'workOrder':
        return dprData.workOrder;
      case 'inceptionReport':
        return dprData.inceptionReport;
      case 'survey':
        return dprData.survey;
      case 'alignmentLayout':
        return dprData.alignmentLayout;
      case 'draftDPR':
        return dprData.draftDPR;
      case 'drawings':
        return dprData.drawings;
      case 'boq':
        return dprData.boq;
      case 'envClearance':
        return dprData.envClearance;
      case 'cashFlow':
        return dprData.cashFlow;
      case 'laProposal':
        return dprData.laProposal;
      case 'utilityShifting':
        return dprData.utilityShifting;
      case 'finalDPR':
        return dprData.finalDPR;
      case 'bidDocWork':
        return dprData.bidDocWork;
      default:
        return null;
    }
  }

  void _setDateForField(String field, DateTime date) {
    switch (field) {
      case 'bidDocDPR':
        dprData.bidDocDPR = date;
        break;
      case 'tenderInvite':
        dprData.tenderInvite = date;
        break;
      case 'prebid':
        dprData.prebid = date;
        break;
      case 'csd':
        dprData.csd = date;
        break;
      case 'bidSubmit':
        dprData.bidSubmit = date;
        break;
      case 'workOrder':
        dprData.workOrder = date;
        break;
      case 'inceptionReport':
        dprData.inceptionReport = date;
        break;
      case 'survey':
        dprData.survey = date;
        break;
      case 'alignmentLayout':
        dprData.alignmentLayout = date;
        break;
      case 'draftDPR':
        dprData.draftDPR = date;
        break;
      case 'drawings':
        dprData.drawings = date;
        break;
      case 'boq':
        dprData.boq = date;
        break;
      case 'envClearance':
        dprData.envClearance = date;
        break;
      case 'cashFlow':
        dprData.cashFlow = date;
        break;
      case 'laProposal':
        dprData.laProposal = date;
        break;
      case 'utilityShifting':
        dprData.utilityShifting = date;
        break;
      case 'finalDPR':
        dprData.finalDPR = date;
        break;
      case 'bidDocWork':
        dprData.bidDocWork = date;
        break;
    }
  }

  void saveChanges() {
    dprData.broadScope = broadScopeController.text.isNotEmpty ? broadScopeController.text : null;
    widget.project.dprData = dprData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      isEditing = false;
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
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(Map<String, String> fieldInfo) {
    if (widget.searchQuery.isEmpty) return true;
    final query = widget.searchQuery.toLowerCase();
    return fieldInfo['label']!.toLowerCase().contains(query) ||
        (fieldInfo['responsiblePerson']?.toLowerCase().contains(query) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredFields = <int>[];
    for (int i = 0; i < AppConstants.dprFields.length; i++) {
      if (_matchesSearch(AppConstants.dprFields[i])) {
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
                      controller: broadScopeController,
                      enabled: isEditing,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Enter broad scope of work...',
                        filled: true,
                        fillColor: isEditing ? Colors.white : Colors.grey.shade100,
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
