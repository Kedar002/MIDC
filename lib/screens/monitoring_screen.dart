import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/monitoring_data.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../services/data_service.dart';

class MonitoringScreen extends StatefulWidget {
  final Project project;
  final String searchQuery;

  const MonitoringScreen({super.key, required this.project, this.searchQuery = ''});

  @override
  State<MonitoringScreen> createState() => MonitoringScreenState();
}

class MonitoringScreenState extends State<MonitoringScreen> {
  late MonitoringData monitoringData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool isEditing = false;

  final TextEditingController _agreementAmountController = TextEditingController();
  final TextEditingController _tenderPeriodController = TextEditingController();
  final TextEditingController _firstMilestoneController = TextEditingController();
  final TextEditingController _secondMilestoneController = TextEditingController();
  final TextEditingController _thirdMilestoneController = TextEditingController();
  final TextEditingController _fourthMilestoneController = TextEditingController();
  final TextEditingController _fifthMilestoneController = TextEditingController();
  final TextEditingController _ldController = TextEditingController();
  final TextEditingController _cosController = TextEditingController();
  final TextEditingController _eotController = TextEditingController();
  final TextEditingController _cumulativeExpenditureController = TextEditingController();
  final TextEditingController _finalBillController = TextEditingController();
  final TextEditingController _auditParaController = TextEditingController();
  final TextEditingController _repliesController = TextEditingController();
  final TextEditingController _laqLcqController = TextEditingController();
  final TextEditingController _techAuditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    monitoringData = widget.project.monitoringData ?? MonitoringData();
    initializeControllers();
  }

  void initializeControllers() {
    _agreementAmountController.text = monitoringData.agreementAmount?.toString() ?? '';
    _tenderPeriodController.text = monitoringData.tenderPeriod ?? '';
    _firstMilestoneController.text = monitoringData.firstMilestone?.toString() ?? '';
    _secondMilestoneController.text = monitoringData.secondMilestone?.toString() ?? '';
    _thirdMilestoneController.text = monitoringData.thirdMilestone?.toString() ?? '';
    _fourthMilestoneController.text = monitoringData.fourthMilestone?.toString() ?? '';
    _fifthMilestoneController.text = monitoringData.fifthMilestone?.toString() ?? '';
    _ldController.text = monitoringData.ld ?? '';
    _cosController.text = monitoringData.cos ?? '';
    _eotController.text = monitoringData.eot ?? '';
    _cumulativeExpenditureController.text = monitoringData.cumulativeExpenditure?.toString() ?? '';
    _finalBillController.text = monitoringData.finalBill?.toString() ?? '';
    _auditParaController.text = monitoringData.auditPara ?? '';
    _repliesController.text = monitoringData.replies ?? '';
    _laqLcqController.text = monitoringData.laqLcq ?? '';
    _techAuditController.text = monitoringData.techAudit ?? '';
  }

  @override
  void dispose() {
    _agreementAmountController.dispose();
    _tenderPeriodController.dispose();
    _firstMilestoneController.dispose();
    _secondMilestoneController.dispose();
    _thirdMilestoneController.dispose();
    _fourthMilestoneController.dispose();
    _fifthMilestoneController.dispose();
    _ldController.dispose();
    _cosController.dispose();
    _eotController.dispose();
    _cumulativeExpenditureController.dispose();
    _finalBillController.dispose();
    _auditParaController.dispose();
    _repliesController.dispose();
    _laqLcqController.dispose();
    _techAuditController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = monitoringData.appointedDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        monitoringData.appointedDate = pickedDate;
      });
    }
  }

  void saveChanges() {
    monitoringData.agreementAmount = double.tryParse(_agreementAmountController.text);
    monitoringData.tenderPeriod = _tenderPeriodController.text.isNotEmpty ? _tenderPeriodController.text : null;
    monitoringData.firstMilestone = int.tryParse(_firstMilestoneController.text);
    monitoringData.secondMilestone = int.tryParse(_secondMilestoneController.text);
    monitoringData.thirdMilestone = int.tryParse(_thirdMilestoneController.text);
    monitoringData.fourthMilestone = int.tryParse(_fourthMilestoneController.text);
    monitoringData.fifthMilestone = int.tryParse(_fifthMilestoneController.text);
    monitoringData.ld = _ldController.text.isNotEmpty ? _ldController.text : null;
    monitoringData.cos = _cosController.text.isNotEmpty ? _cosController.text : null;
    monitoringData.eot = _eotController.text.isNotEmpty ? _eotController.text : null;
    monitoringData.cumulativeExpenditure = double.tryParse(_cumulativeExpenditureController.text);
    monitoringData.finalBill = double.tryParse(_finalBillController.text);
    monitoringData.auditPara = _auditParaController.text.isNotEmpty ? _auditParaController.text : null;
    monitoringData.replies = _repliesController.text.isNotEmpty ? _repliesController.text : null;
    monitoringData.laqLcq = _laqLcqController.text.isNotEmpty ? _laqLcqController.text : null;
    monitoringData.techAudit = _techAuditController.text.isNotEmpty ? _techAuditController.text : null;

    widget.project.monitoringData = monitoringData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Monitoring data saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String responsiblePerson,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? suffix,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.captionSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              'Responsible: $responsiblePerson',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            TextField(
              controller: controller,
              enabled: isEditing,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLines: maxLines,
              style: AppTextStyles.labelSmall,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.captionSmall,
                filled: true,
                fillColor: isEditing ? AppColors.background : AppColors.surface,
                suffixText: suffix,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final date = monitoringData.appointedDate;
    final dateString = date != null ? _dateFormat.format(date) : 'Not set';

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Appointed Date',
                    style: AppTextStyles.captionSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: Icon(Icons.calendar_month_outlined, size: AppSpacing.iconXs),
                    onPressed: () => _selectDate(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              'Responsible: SE',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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
                    date != null ? Icons.check_circle_outline : Icons.circle_outlined,
                    size: AppSpacing.iconXs,
                    color: date != null ? AppColors.success : AppColors.textTertiary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    dateString,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: date != null ? AppColors.textPrimary : AppColors.textTertiary,
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

  Widget _buildMilestoneCard({
    required String label,
    required TextEditingController controller,
  }) {
    final progress = int.tryParse(controller.text) ?? 0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.captionSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              'Responsible: EE',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'^([0-9]|[1-9][0-9]|100)$')),
                    ],
                    style: AppTextStyles.labelSmall,
                    decoration: InputDecoration(
                      hintText: '0-100',
                      hintStyle: AppTextStyles.captionSmall,
                      filled: true,
                      fillColor: isEditing ? AppColors.background : AppColors.surface,
                      suffixText: '%',
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 0
                      ? AppColors.warning
                      : progress == 100
                          ? AppColors.success
                          : AppColors.accentCyan,
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(String label) {
    if (widget.searchQuery.isEmpty) return true;
    final query = widget.searchQuery.toLowerCase();
    return label.toLowerCase().contains(query);
  }

  List<int> _getFilteredIndices() {
    final labels = [
      'Agreement Amount',
      'Date of Appointment',
      'Tender Period',
      'Cumulative Expenditure',
      'Final Bill',
      'First Milestone',
      'Second Milestone',
      'Third Milestone',
      'Fourth Milestone',
      'Fifth Milestone',
      'LD (Liquidated Damages)',
      'COS (Change of Scope)',
      'EOT (Extension of Time)',
      'Audit Para',
      'Replies',
      'LAQ/LCQ',
      'Technical Audit',
    ];

    final filtered = <int>[];
    for (int i = 0; i < labels.length; i++) {
      if (_matchesSearch(labels[i])) {
        filtered.add(i);
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndices = _getFilteredIndices();

    if (filteredIndices.isEmpty && widget.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 64, color: AppColors.textTertiary),
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
        mainAxisExtent: 160,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: filteredIndices.length,
      itemBuilder: (context, idx) {
        final index = filteredIndices[idx];
              // Financial Information (0-4)
              if (index == 0) {
                return _buildTextField(
                  label: 'Agreement Amount',
                  responsiblePerson: 'EE',
                  controller: _agreementAmountController,
                  hintText: 'Enter amount in Crores',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  suffix: 'Cr',
                );
              } else if (index == 1) {
                return _buildDateField();
              } else if (index == 2) {
                return _buildTextField(
                  label: 'Tender Period',
                  responsiblePerson: 'EE',
                  controller: _tenderPeriodController,
                  hintText: 'e.g., 24 months',
                );
              } else if (index == 3) {
                return _buildTextField(
                  label: 'Cumulative Expenditure',
                  responsiblePerson: 'Fin',
                  controller: _cumulativeExpenditureController,
                  hintText: 'Enter amount in Crores',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  suffix: 'Cr',
                );
              } else if (index == 4) {
                return _buildTextField(
                  label: 'Final Bill',
                  responsiblePerson: 'JMD',
                  controller: _finalBillController,
                  hintText: 'Enter amount in Crores',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  suffix: 'Cr',
                );
              }
              // Milestone Progress (5-9)
              else if (index == 5) {
                return _buildMilestoneCard(
                  label: 'First Milestone',
                  controller: _firstMilestoneController,
                );
              } else if (index == 6) {
                return _buildMilestoneCard(
                  label: 'Second Milestone',
                  controller: _secondMilestoneController,
                );
              } else if (index == 7) {
                return _buildMilestoneCard(
                  label: 'Third Milestone',
                  controller: _thirdMilestoneController,
                );
              } else if (index == 8) {
                return _buildMilestoneCard(
                  label: 'Fourth Milestone',
                  controller: _fourthMilestoneController,
                );
              } else if (index == 9) {
                return _buildMilestoneCard(
                  label: 'Fifth Milestone',
                  controller: _fifthMilestoneController,
                );
              }
              // Project Issues & Changes (10-12)
              else if (index == 10) {
                return _buildTextField(
                  label: 'LD (Liquidated Damages)',
                  responsiblePerson: 'EE',
                  controller: _ldController,
                  hintText: 'Enter LD details',
                  maxLines: 2,
                );
              } else if (index == 11) {
                return _buildTextField(
                  label: 'COS (Change of Scope)',
                  responsiblePerson: 'CE',
                  controller: _cosController,
                  hintText: 'Enter COS details',
                  maxLines: 2,
                );
              } else if (index == 12) {
                return _buildTextField(
                  label: 'EOT (Extension of Time)',
                  responsiblePerson: 'JMD',
                  controller: _eotController,
                  hintText: 'Enter EOT details',
                  maxLines: 2,
                );
              }
              // Audit & Compliance (13-17)
              else if (index == 13) {
                return _buildTextField(
                  label: 'Audit Para',
                  responsiblePerson: 'Fin',
                  controller: _auditParaController,
                  hintText: 'Enter audit para details',
                  maxLines: 2,
                );
              } else if (index == 14) {
                return _buildTextField(
                  label: 'Replies',
                  responsiblePerson: 'SE',
                  controller: _repliesController,
                  hintText: 'Enter replies',
                  maxLines: 2,
                );
              } else if (index == 15) {
                return _buildTextField(
                  label: 'LAQ / LCQ',
                  responsiblePerson: 'SE',
                  controller: _laqLcqController,
                  hintText: 'Enter LAQ/LCQ details',
                  maxLines: 2,
                );
              } else if (index == 16) {
                return _buildTextField(
                  label: 'Technical Audit',
                  responsiblePerson: 'JMD',
                  controller: _techAuditController,
                  hintText: 'Enter tech audit details',
                  maxLines: 2,
                );
              }

              return const SizedBox.shrink();
            },
          );
  }
}
