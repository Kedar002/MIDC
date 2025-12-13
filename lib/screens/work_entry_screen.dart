import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import '../models/work_entry_data.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../services/data_service.dart';

class WorkEntryScreen extends StatefulWidget {
  final Project project;

  const WorkEntryScreen({super.key, required this.project});

  @override
  State<WorkEntryScreen> createState() => _WorkEntryScreenState();
}

class _WorkEntryScreenState extends State<WorkEntryScreen> {
  late List<WorkEntryActivity> _activities;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool _isEditing = false;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _initializeActivities();
  }

  void _initializeActivities() {
    if (widget.project.workEntryActivities != null && widget.project.workEntryActivities!.isNotEmpty) {
      _activities = List.from(widget.project.workEntryActivities!);
    } else {
      _activities = AppConstants.workEntryActivities
          .map((name) => WorkEntryActivity(particulars: name))
          .toList();
    }
  }

  Future<void> _selectDate(BuildContext context, int index, bool isStartDate) async {
    final activity = _activities[index];
    final initialDate = isStartDate
        ? (activity.startDate ?? DateTime.now())
        : (activity.endDate ?? activity.startDate ?? DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _activities[index].startDate = pickedDate;
          // Auto-calculate end date if period is set
          if (_activities[index].periodDays != null && _activities[index].periodDays! > 0) {
            _activities[index].endDate = pickedDate.add(Duration(days: _activities[index].periodDays!));
          }
        } else {
          _activities[index].endDate = pickedDate;
          // Auto-calculate period if start date is set
          if (_activities[index].startDate != null) {
            _activities[index].periodDays = pickedDate.difference(_activities[index].startDate!).inDays;
          }
        }
      });
    }
  }

  void _saveChanges() {
    widget.project.workEntryActivities = _activities;
    context.read<DataService>().updateProject(widget.project);
    setState(() {
      _isEditing = false;
      _expandedIndex = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work entry data saved successfully'),
        backgroundColor: AppTheme.statusCompleted,
      ),
    );
  }

  Color _getActivityStatusColor(WorkEntryActivity activity) {
    if (activity.isCompleted) return AppTheme.statusCompleted;
    if (activity.isInProgress) return AppTheme.statusInProgress;
    return AppTheme.statusPending;
  }

  IconData _getActivityStatusIcon(WorkEntryActivity activity) {
    if (activity.isCompleted) return Icons.check_circle;
    if (activity.isInProgress) return Icons.pending;
    return Icons.radio_button_unchecked;
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
              const Icon(Icons.edit_note, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Work Entry Details',
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
                      _initializeActivities();
                      _isEditing = false;
                      _expandedIndex = null;
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _activities.length,
            itemBuilder: (context, index) {
              final activity = _activities[index];
              final isExpanded = _expandedIndex == index;
              final statusColor = _getActivityStatusColor(activity);
              final statusIcon = _getActivityStatusIcon(activity);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: statusColor.withOpacity(0.1),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        activity.particulars,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      subtitle: activity.startDate != null
                          ? Text(
                              'Start: ${_dateFormat.format(activity.startDate!)}${activity.endDate != null ? ' • End: ${_dateFormat.format(activity.endDate!)}' : ''}',
                              style: const TextStyle(fontSize: 12),
                            )
                          : const Text(
                              'Not started',
                              style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                            ),
                      trailing: _isEditing
                          ? IconButton(
                              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                              onPressed: () {
                                setState(() {
                                  _expandedIndex = isExpanded ? null : index;
                                });
                              },
                            )
                          : Icon(statusIcon, color: statusColor, size: 20),
                      onTap: _isEditing
                          ? () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            }
                          : null,
                    ),
                    if (isExpanded && _isEditing) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Start Date',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => _selectDate(context, index, true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.calendar_today, size: 16),
                                              const SizedBox(width: 8),
                                              Text(
                                                activity.startDate != null
                                                    ? _dateFormat.format(activity.startDate!)
                                                    : 'Select start date',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: activity.startDate != null
                                                      ? AppTheme.textPrimary
                                                      : AppTheme.textHint,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Period (Days)',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: 'Days',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        ),
                                        controller: TextEditingController(
                                          text: activity.periodDays?.toString() ?? '',
                                        ),
                                        onChanged: (value) {
                                          final days = int.tryParse(value);
                                          setState(() {
                                            _activities[index].periodDays = days;
                                            if (days != null && activity.startDate != null) {
                                              _activities[index].endDate =
                                                  activity.startDate!.add(Duration(days: days));
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'End Date',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => _selectDate(context, index, false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.calendar_today, size: 16),
                                              const SizedBox(width: 8),
                                              Text(
                                                activity.endDate != null
                                                    ? _dateFormat.format(activity.endDate!)
                                                    : 'Select end date',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: activity.endDate != null
                                                      ? AppTheme.textPrimary
                                                      : AppTheme.textHint,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Person Responsible',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField<String>(
                                        value: activity.personResponsible,
                                        decoration: const InputDecoration(
                                          hintText: 'Select person',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        ),
                                        items: AppConstants.responsiblePersons.map((person) {
                                          return DropdownMenuItem(
                                            value: person,
                                            child: Text(person, style: const TextStyle(fontSize: 13)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _activities[index].personResponsible = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Post Held',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField<String>(
                                        value: activity.postHeld,
                                        decoration: const InputDecoration(
                                          hintText: 'Select post',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        ),
                                        items: AppConstants.postHeld.map((post) {
                                          return DropdownMenuItem(
                                            value: post,
                                            child: Text(post, style: const TextStyle(fontSize: 13)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _activities[index].postHeld = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pending With',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter pending with whom',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  controller: TextEditingController(text: activity.pendingWith ?? ''),
                                  onChanged: (value) {
                                    _activities[index].pendingWith = value.isNotEmpty ? value : null;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
