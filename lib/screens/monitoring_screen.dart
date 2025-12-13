import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/monitoring_data.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class MonitoringScreen extends StatefulWidget {
  final Project project;

  const MonitoringScreen({super.key, required this.project});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  late MonitoringData _monitoringData;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool _isEditing = false;

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
    _monitoringData = widget.project.monitoringData ?? MonitoringData();
    _initializeControllers();
  }

  void _initializeControllers() {
    _agreementAmountController.text = _monitoringData.agreementAmount?.toString() ?? '';
    _tenderPeriodController.text = _monitoringData.tenderPeriod ?? '';
    _firstMilestoneController.text = _monitoringData.firstMilestone?.toString() ?? '';
    _secondMilestoneController.text = _monitoringData.secondMilestone?.toString() ?? '';
    _thirdMilestoneController.text = _monitoringData.thirdMilestone?.toString() ?? '';
    _fourthMilestoneController.text = _monitoringData.fourthMilestone?.toString() ?? '';
    _fifthMilestoneController.text = _monitoringData.fifthMilestone?.toString() ?? '';
    _ldController.text = _monitoringData.ld ?? '';
    _cosController.text = _monitoringData.cos ?? '';
    _eotController.text = _monitoringData.eot ?? '';
    _cumulativeExpenditureController.text = _monitoringData.cumulativeExpenditure?.toString() ?? '';
    _finalBillController.text = _monitoringData.finalBill?.toString() ?? '';
    _auditParaController.text = _monitoringData.auditPara ?? '';
    _repliesController.text = _monitoringData.replies ?? '';
    _laqLcqController.text = _monitoringData.laqLcq ?? '';
    _techAuditController.text = _monitoringData.techAudit ?? '';
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
    final initialDate = _monitoringData.appointedDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _monitoringData.appointedDate = pickedDate;
      });
    }
  }

  void _saveChanges() {
    _monitoringData.agreementAmount = double.tryParse(_agreementAmountController.text);
    _monitoringData.tenderPeriod = _tenderPeriodController.text.isNotEmpty ? _tenderPeriodController.text : null;
    _monitoringData.firstMilestone = int.tryParse(_firstMilestoneController.text);
    _monitoringData.secondMilestone = int.tryParse(_secondMilestoneController.text);
    _monitoringData.thirdMilestone = int.tryParse(_thirdMilestoneController.text);
    _monitoringData.fourthMilestone = int.tryParse(_fourthMilestoneController.text);
    _monitoringData.fifthMilestone = int.tryParse(_fifthMilestoneController.text);
    _monitoringData.ld = _ldController.text.isNotEmpty ? _ldController.text : null;
    _monitoringData.cos = _cosController.text.isNotEmpty ? _cosController.text : null;
    _monitoringData.eot = _eotController.text.isNotEmpty ? _eotController.text : null;
    _monitoringData.cumulativeExpenditure = double.tryParse(_cumulativeExpenditureController.text);
    _monitoringData.finalBill = double.tryParse(_finalBillController.text);
    _monitoringData.auditPara = _auditParaController.text.isNotEmpty ? _auditParaController.text : null;
    _monitoringData.replies = _repliesController.text.isNotEmpty ? _repliesController.text : null;
    _monitoringData.laqLcq = _laqLcqController.text.isNotEmpty ? _laqLcqController.text : null;
    _monitoringData.techAudit = _techAuditController.text.isNotEmpty ? _techAuditController.text : null;

    widget.project.monitoringData = _monitoringData;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Monitoring data saved successfully'),
        backgroundColor: AppTheme.statusCompleted,
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
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Responsible: $responsiblePerson',
              style: const TextStyle(
                fontSize: 9,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              enabled: _isEditing,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 11),
                filled: true,
                fillColor: _isEditing ? Colors.white : Colors.grey.shade100,
                suffixText: suffix,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final date = _monitoringData.appointedDate;
    final dateString = date != null ? _dateFormat.format(date) : 'Not set';

    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Appointed Date',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 14),
                    onPressed: () => _selectDate(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Responsible: SE',
              style: TextStyle(
                fontSize: 9,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                    size: 12,
                    color: date != null ? AppTheme.statusCompleted : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateString,
                    style: TextStyle(
                      fontSize: 11,
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

  Widget _buildMilestoneCard({
    required String label,
    required TextEditingController controller,
  }) {
    final progress = int.tryParse(controller.text) ?? 0;

    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Responsible: EE',
              style: TextStyle(
                fontSize: 9,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'^([0-9]|[1-9][0-9]|100)$')),
                    ],
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: '0-100',
                      hintStyle: const TextStyle(fontSize: 11),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade100,
                      suffixText: '%',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 0
                    ? AppTheme.statusPending
                    : progress == 100
                        ? AppTheme.statusCompleted
                        : AppTheme.statusInProgress,
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
              const Icon(Icons.analytics, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Project Monitoring',
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
                      _monitoringData = widget.project.monitoringData ?? MonitoringData();
                      _initializeControllers();
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
              mainAxisExtent: 160,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 17,
            itemBuilder: (context, index) {
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
          ),
        ),
      ],
    );
  }
}
