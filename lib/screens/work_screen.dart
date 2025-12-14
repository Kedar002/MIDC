import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/work_data.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
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
      SnackBar(
        content: Text('Changes saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildDateField(String fieldName, Map<String, String> fieldInfo) {
    final date = _getDateForField(fieldName);
    final dateString = date != null ? _dateFormat.format(date) : 'Not set';

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    fieldInfo['label']!,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: Icon(Icons.calendar_today, size: AppSpacing.iconSm),
                    onPressed: () => _selectDate(context, fieldName),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Responsible: ${fieldInfo['responsiblePerson']}',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: date != null
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: date != null
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    date != null ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: AppSpacing.iconSm,
                    color: date != null ? AppColors.success : AppColors.textTertiary,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    dateString,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: date != null ? AppColors.textPrimary : AppColors.textTertiary,
                      fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (fieldInfo['fullName'] != null && fieldInfo['fullName'] != fieldInfo['label']) ...[
              SizedBox(height: AppSpacing.xs),
              Text(
                fieldInfo['fullName']!,
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.textTertiary,
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
            Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No results found for "${widget.searchQuery}"',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 140,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
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
