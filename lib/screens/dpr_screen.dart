import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
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
  final TextEditingController successfulBidderController = TextEditingController();
  final TextEditingController loaDelayReasonsController = TextEditingController();
  final TextEditingController surveyDelayReasonsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dprData = widget.project.dprData ?? DPRData();
    broadScopeController.text = dprData.broadScope ?? '';
    successfulBidderController.text = dprData.successfulBidderName ?? '';
    loaDelayReasonsController.text = dprData.loaDelayReasons ?? '';
    surveyDelayReasonsController.text = dprData.surveyDelayReasons ?? '';
  }

  @override
  void dispose() {
    broadScopeController.dispose();
    successfulBidderController.dispose();
    loaDelayReasonsController.dispose();
    surveyDelayReasonsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  void saveChanges() {
    dprData.broadScope = broadScopeController.text.isNotEmpty ? broadScopeController.text : null;
    dprData.successfulBidderName = successfulBidderController.text.isNotEmpty ? successfulBidderController.text : null;
    dprData.loaDelayReasons = loaDelayReasonsController.text.isNotEmpty ? loaDelayReasonsController.text : null;
    dprData.surveyDelayReasons = surveyDelayReasonsController.text.isNotEmpty ? surveyDelayReasonsController.text : null;

    widget.project.dprData = dprData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('DPR data saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.h6.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildRadioStatusField({
    required String label,
    required WorkflowStatus? value,
    required Function(WorkflowStatus?) onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: WorkflowStatus.values.map((status) {
                return InkWell(
                  onTap: isEditing ? () => onChanged(status) : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<WorkflowStatus>(
                        value: status,
                        groupValue: value,
                        onChanged: isEditing ? onChanged : null,
                      ),
                      Text(
                        status.displayName,
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioStatusWithDateField({
    required String label,
    required WorkflowStatus? status,
    required Function(WorkflowStatus?) onStatusChanged,
    required DateTime? date,
    required Function(DateTime) onDateChanged,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: WorkflowStatus.values.map((s) {
                return InkWell(
                  onTap: isEditing ? () => onStatusChanged(s) : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<WorkflowStatus>(
                        value: s,
                        groupValue: status,
                        onChanged: isEditing ? onStatusChanged : null,
                      ),
                      Text(
                        s.displayName,
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (status != WorkflowStatus.notStarted) ...[
              SizedBox(height: AppSpacing.md),
              Divider(color: AppColors.border),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Text(
                    'Date:',
                    style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: InkWell(
                      onTap: isEditing ? () => _selectDate(context, onDateChanged) : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          color: isEditing ? AppColors.background : AppColors.surface,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined, size: AppSpacing.iconSm),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              date != null ? _dateFormat.format(date) : 'Select date',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: date != null ? AppColors.textPrimary : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateChanged,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            InkWell(
              onTap: isEditing ? () => _selectDate(context, onDateChanged) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  color: isEditing ? AppColors.background : AppColors.surface,
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: AppSpacing.iconSm),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      date != null ? _dateFormat.format(date) : 'Select date',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: date != null ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required int? value,
    required Function(int?) onChanged,
    String? hint,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              enabled: isEditing,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController(text: value?.toString() ?? ''),
              decoration: InputDecoration(
                hintText: hint ?? 'Enter number',
                filled: true,
                fillColor: isEditing ? AppColors.background : AppColors.surface,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
              onChanged: (val) {
                onChanged(int.tryParse(val));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              enabled: isEditing,
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint ?? 'Enter text',
                filled: true,
                fillColor: isEditing ? AppColors.background : AppColors.surface,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureField({
    required String label,
    required int? nos,
    required Function(int?) onNosChanged,
    required WorkflowStatus? status,
    required Function(WorkflowStatus?) onStatusChanged,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: TextEditingController(text: nos?.toString() ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Nos.',
                      filled: true,
                      fillColor: isEditing ? AppColors.background : AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onChanged: (val) {
                      onNosChanged(int.tryParse(val));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: WorkflowStatus.values.map((s) {
                return InkWell(
                  onTap: isEditing ? () => onStatusChanged(s) : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<WorkflowStatus>(
                        value: s,
                        groupValue: status,
                        onChanged: isEditing ? onStatusChanged : null,
                      ),
                      Text(
                        s.displayName,
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPBGField() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Bank Guarantee (PBG)',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('Date:', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w500)),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: InkWell(
                    onTap: isEditing ? () => _selectDate(context, (date) => dprData.pbgDate = date) : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        color: isEditing ? AppColors.background : AppColors.surface,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_outlined, size: AppSpacing.iconSm),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            dprData.pbgDate != null ? _dateFormat.format(dprData.pbgDate!) : 'Select date',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: dprData.pbgDate != null ? AppColors.textPrimary : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isEditing,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController(text: dprData.pbgAmount?.toString() ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      filled: true,
                      fillColor: isEditing ? AppColors.background : AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onChanged: (val) {
                      setState(() {
                        dprData.pbgAmount = double.tryParse(val);
                      });
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    enabled: isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: TextEditingController(text: dprData.pbgPeriodDays?.toString() ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Period (Days)',
                      filled: true,
                      fillColor: isEditing ? AppColors.background : AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onChanged: (val) {
                      setState(() {
                        dprData.pbgPeriodDays = int.tryParse(val);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(String text) {
    if (widget.searchQuery.isEmpty) return true;
    final query = widget.searchQuery.toLowerCase();
    return text.toLowerCase().contains(query);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
      children: [
        // 1. Broad Scope of Work
        if (_matchesSearch('Broad Scope of Work'))
          _buildTextField(
            label: 'Broad Scope of Work (Max 500 words)',
            controller: broadScopeController,
            hint: 'Enter broad scope of work...',
            maxLines: 5,
          ),

        // 2. Bid Document for DPR
        if (_matchesSearch('Bid Document for DPR'))
          _buildRadioStatusWithDateField(
            label: 'Bid Document for DPR',
            status: dprData.bidDocDPRStatus,
            onStatusChanged: (status) => setState(() => dprData.bidDocDPRStatus = status),
            date: dprData.bidDocDPRDate,
            onDateChanged: (date) => dprData.bidDocDPRDate = date,
          ),

        // 3. Tender Invite
        if (_matchesSearch('Tender Invite'))
          _buildDateField(
            label: 'Tender Invite',
            date: dprData.tenderInviteDate,
            onDateChanged: (date) => dprData.tenderInviteDate = date,
          ),

        // 4. No. of qualified bidders
        if (_matchesSearch('No. of qualified bidders'))
          _buildNumberField(
            label: 'No. of qualified bidders',
            value: dprData.qualifiedBidders,
            onChanged: (val) => setState(() => dprData.qualifiedBidders = val),
          ),

        // 5. Successful bidder name
        if (_matchesSearch('Successful bidder name'))
          _buildTextField(
            label: 'Successful bidder name',
            controller: successfulBidderController,
            hint: 'Enter successful bidder name',
          ),

        // 6. Prebid Meeting
        if (_matchesSearch('Prebid Meeting'))
          _buildRadioStatusWithDateField(
            label: 'Prebid Meeting',
            status: dprData.prebidStatus,
            onStatusChanged: (status) => setState(() => dprData.prebidStatus = status),
            date: dprData.prebidDate,
            onDateChanged: (date) => dprData.prebidDate = date,
          ),

        // 7. CSD Date
        if (_matchesSearch('CSD'))
          _buildDateField(
            label: 'CSD',
            date: dprData.csdDate,
            onDateChanged: (date) => dprData.csdDate = date,
          ),

        // 8. Bid Submit
        if (_matchesSearch('Bid Submit'))
          _buildDateField(
            label: 'Bid Submit',
            date: dprData.bidSubmitDate,
            onDateChanged: (date) => dprData.bidSubmitDate = date,
          ),

        // 9. Financial Bid Opening
        if (_matchesSearch('Financial Bid Opening'))
          _buildDateField(
            label: 'Financial Bid Opening',
            date: dprData.finBidDate,
            onDateChanged: (date) => dprData.finBidDate = date,
          ),

        // 10. LOI
        if (_matchesSearch('LOI'))
          _buildRadioStatusWithDateField(
            label: 'LOI (Letter of Intent)',
            status: dprData.loiStatus,
            onStatusChanged: (status) => setState(() => dprData.loiStatus = status),
            date: dprData.loiDate,
            onDateChanged: (date) => dprData.loiDate = date,
          ),

        // 11. LOA with conditional delay reasons
        if (_matchesSearch('LOA')) ...[
          _buildRadioStatusWithDateField(
            label: 'LOA (Letter of Acceptance)',
            status: dprData.loaStatus,
            onStatusChanged: (status) => setState(() => dprData.loaStatus = status),
            date: dprData.loaDate,
            onDateChanged: (date) => dprData.loaDate = date,
          ),
          if (dprData.loaStatus == WorkflowStatus.inProgress)
            _buildTextField(
              label: 'Reasons for delay in LOA',
              controller: loaDelayReasonsController,
              hint: 'Enter reasons for delay',
              maxLines: 3,
            ),
        ],

        // 12. PBG
        if (_matchesSearch('PBG') || _matchesSearch('Performance Bank Guarantee'))
          _buildPBGField(),

        // 13. Agreement
        if (_matchesSearch('Agreement'))
          _buildRadioStatusWithDateField(
            label: 'Agreement',
            status: dprData.agreementStatus,
            onStatusChanged: (status) => setState(() => dprData.agreementStatus = status),
            date: dprData.agreementDate,
            onDateChanged: (date) => dprData.agreementDate = date,
          ),

        // 14. Work Order
        if (_matchesSearch('Work Order'))
          _buildRadioStatusWithDateField(
            label: 'Work Order',
            status: dprData.workOrderStatus,
            onStatusChanged: (status) => setState(() => dprData.workOrderStatus = status),
            date: dprData.workOrderDate,
            onDateChanged: (date) => dprData.workOrderDate = date,
          ),

        // DPR Preparation Section
        if (_matchesSearch('DPR') || _matchesSearch('Inception') || _matchesSearch('Survey') ||
            _matchesSearch('Alignment') || _matchesSearch('Draft') || _matchesSearch('Drawing') ||
            _matchesSearch('BOQ') || _matchesSearch('Environmental') || _matchesSearch('Cash Flow') ||
            _matchesSearch('LA Proposal') || _matchesSearch('Utility'))
          _buildSectionHeader('DPR Preparation'),

        // 15. Inception Report
        if (_matchesSearch('Inception Report'))
          _buildRadioStatusWithDateField(
            label: 'Inception Report',
            status: dprData.inceptionReportStatus,
            onStatusChanged: (status) => setState(() => dprData.inceptionReportStatus = status),
            date: dprData.inceptionReportDate,
            onDateChanged: (date) => dprData.inceptionReportDate = date,
          ),

        // 16. Survey with conditional delay reasons
        if (_matchesSearch('Survey')) ...[
          _buildRadioStatusWithDateField(
            label: 'Survey',
            status: dprData.surveyStatus,
            onStatusChanged: (status) => setState(() => dprData.surveyStatus = status),
            date: dprData.surveyDate,
            onDateChanged: (date) => dprData.surveyDate = date,
          ),
          if (dprData.surveyStatus == WorkflowStatus.inProgress)
            _buildTextField(
              label: 'Reasons for delay in Survey',
              controller: surveyDelayReasonsController,
              hint: 'Enter reasons for delay',
              maxLines: 3,
            ),
        ],

        // 17. Alignment & Layout
        if (_matchesSearch('Alignment') || _matchesSearch('Layout'))
          _buildRadioStatusWithDateField(
            label: 'Alignment & Layout',
            status: dprData.alignmentLayoutStatus,
            onStatusChanged: (status) => setState(() => dprData.alignmentLayoutStatus = status),
            date: dprData.alignmentLayoutDate,
            onDateChanged: (date) => dprData.alignmentLayoutDate = date,
          ),

        // 18. Draft DPR
        if (_matchesSearch('Draft DPR'))
          _buildRadioStatusWithDateField(
            label: 'Draft DPR',
            status: dprData.draftDPRStatus,
            onStatusChanged: (status) => setState(() => dprData.draftDPRStatus = status),
            date: dprData.draftDPRDate,
            onDateChanged: (date) => dprData.draftDPRDate = date,
          ),

        // 19. Drawings
        if (_matchesSearch('Drawings'))
          _buildRadioStatusWithDateField(
            label: 'Drawings',
            status: dprData.drawingsStatus,
            onStatusChanged: (status) => setState(() => dprData.drawingsStatus = status),
            date: dprData.drawingsDate,
            onDateChanged: (date) => dprData.drawingsDate = date,
          ),

        // 20. BOQ
        if (_matchesSearch('BOQ'))
          _buildRadioStatusWithDateField(
            label: 'BOQ (Bill of Quantities)',
            status: dprData.boqStatus,
            onStatusChanged: (status) => setState(() => dprData.boqStatus = status),
            date: dprData.boqDate,
            onDateChanged: (date) => dprData.boqDate = date,
          ),

        // 21. Environmental Clearance
        if (_matchesSearch('Environmental') || _matchesSearch('Clearance'))
          _buildRadioStatusWithDateField(
            label: 'Environmental Clearance',
            status: dprData.envClearanceStatus,
            onStatusChanged: (status) => setState(() => dprData.envClearanceStatus = status),
            date: dprData.envClearanceDate,
            onDateChanged: (date) => dprData.envClearanceDate = date,
          ),

        // 22. Cash Flow
        if (_matchesSearch('Cash Flow'))
          _buildRadioStatusWithDateField(
            label: 'Cash Flow',
            status: dprData.cashFlowStatus,
            onStatusChanged: (status) => setState(() => dprData.cashFlowStatus = status),
            date: dprData.cashFlowDate,
            onDateChanged: (date) => dprData.cashFlowDate = date,
          ),

        // 23. LA Proposal
        if (_matchesSearch('LA Proposal'))
          _buildRadioStatusWithDateField(
            label: 'LA Proposal',
            status: dprData.laProposalStatus,
            onStatusChanged: (status) => setState(() => dprData.laProposalStatus = status),
            date: dprData.laProposalDate,
            onDateChanged: (date) => dprData.laProposalDate = date,
          ),

        // 24. Utility Shifting
        if (_matchesSearch('Utility Shifting'))
          _buildRadioStatusWithDateField(
            label: 'Utility Shifting',
            status: dprData.utilityShiftingStatus,
            onStatusChanged: (status) => setState(() => dprData.utilityShiftingStatus = status),
            date: dprData.utilityShiftingDate,
            onDateChanged: (date) => dprData.utilityShiftingDate = date,
          ),

        // 25. Final DPR
        if (_matchesSearch('Final DPR'))
          _buildRadioStatusWithDateField(
            label: 'Final DPR',
            status: dprData.finalDPRStatus,
            onStatusChanged: (status) => setState(() => dprData.finalDPRStatus = status),
            date: dprData.finalDPRDate,
            onDateChanged: (date) => dprData.finalDPRDate = date,
          ),

        // 26. Bid Document for Work
        if (_matchesSearch('Bid Document for Work'))
          _buildRadioStatusWithDateField(
            label: 'Bid Document for Work',
            status: dprData.bidDocWorkStatus,
            onStatusChanged: (status) => setState(() => dprData.bidDocWorkStatus = status),
            date: dprData.bidDocWorkDate,
            onDateChanged: (date) => dprData.bidDocWorkDate = date,
          ),

        // Structures Section
        if (_matchesSearch('Structure') || _matchesSearch('HPC') || _matchesSearch('Bridge') ||
            _matchesSearch('Culvert') || _matchesSearch('VUP') || _matchesSearch('ROR') ||
            _matchesSearch('Cause'))
          _buildSectionHeader('Structures'),

        // 27. Structure Tracking
        if (_matchesSearch('HPC'))
          _buildStructureField(
            label: 'HPC (High Priority Corridor)',
            nos: dprData.hpcNos,
            onNosChanged: (val) => setState(() => dprData.hpcNos = val),
            status: dprData.hpcStatus,
            onStatusChanged: (status) => setState(() => dprData.hpcStatus = status),
          ),

        if (_matchesSearch('Bridge'))
          _buildStructureField(
            label: 'Bridges',
            nos: dprData.bridgesNos,
            onNosChanged: (val) => setState(() => dprData.bridgesNos = val),
            status: dprData.bridgesStatus,
            onStatusChanged: (status) => setState(() => dprData.bridgesStatus = status),
          ),

        if (_matchesSearch('Culvert'))
          _buildStructureField(
            label: 'Culverts',
            nos: dprData.culvertsNos,
            onNosChanged: (val) => setState(() => dprData.culvertsNos = val),
            status: dprData.culvertsStatus,
            onStatusChanged: (status) => setState(() => dprData.culvertsStatus = status),
          ),

        if (_matchesSearch('VUP'))
          _buildStructureField(
            label: 'VUP (Vehicular Under Pass)',
            nos: dprData.vupNos,
            onNosChanged: (val) => setState(() => dprData.vupNos = val),
            status: dprData.vupStatus,
            onStatusChanged: (status) => setState(() => dprData.vupStatus = status),
          ),

        if (_matchesSearch('ROR'))
          _buildStructureField(
            label: 'ROR (Road Over Rail)',
            nos: dprData.rorNos,
            onNosChanged: (val) => setState(() => dprData.rorNos = val),
            status: dprData.rorStatus,
            onStatusChanged: (status) => setState(() => dprData.rorStatus = status),
          ),

        if (_matchesSearch('Minor Bridge'))
          _buildStructureField(
            label: 'Minor Bridges',
            nos: dprData.minorBridgesNos,
            onNosChanged: (val) => setState(() => dprData.minorBridgesNos = val),
            status: dprData.minorBridgesStatus,
            onStatusChanged: (status) => setState(() => dprData.minorBridgesStatus = status),
          ),

        if (_matchesSearch('Cause') || _matchesSearch('Way'))
          _buildStructureField(
            label: 'Cause Way',
            nos: dprData.causeWayNos,
            onNosChanged: (val) => setState(() => dprData.causeWayNos = val),
            status: dprData.causeWayStatus,
            onStatusChanged: (status) => setState(() => dprData.causeWayStatus = status),
          ),

        // 28. Flyover
        if (_matchesSearch('Flyover'))
          Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              side: BorderSide(color: AppColors.border, width: 1),
            ),
            color: AppColors.surface,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flyover',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    enabled: isEditing,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController(text: dprData.flyoverLengthMeters?.toString() ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Length (meters)',
                      filled: true,
                      fillColor: isEditing ? AppColors.background : AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onChanged: (val) {
                      setState(() {
                        dprData.flyoverLengthMeters = double.tryParse(val);
                      });
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.sm,
                    children: WorkflowStatus.values.map((s) {
                      return InkWell(
                        onTap: isEditing ? () => setState(() => dprData.flyoverStatus = s) : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<WorkflowStatus>(
                              value: s,
                              groupValue: dprData.flyoverStatus,
                              onChanged: isEditing ? (status) => setState(() => dprData.flyoverStatus = status) : null,
                            ),
                            Text(
                              s.displayName,
                              style: AppTextStyles.labelSmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
