import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../models/work_data.dart';
import '../models/monitoring_data.dart';
import '../theme/app_theme.dart';
import 'dpr_screen.dart';
import 'work_screen.dart';
import 'monitoring_screen.dart';
import 'work_entry_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedIndex = 1; // Start with Work tab (index 1)
  bool _isDrawerExpanded = false;
  bool _isDrawerPinned = false;

  // GlobalKeys for accessing child screen states
  final GlobalKey<DPRScreenState> _dprKey = GlobalKey();
  final GlobalKey<WorkScreenState> _workKey = GlobalKey();
  final GlobalKey<MonitoringScreenState> _monitoringKey = GlobalKey();
  final GlobalKey<WorkEntryScreenState> _workEntryKey = GlobalKey();

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'DPR',
      'icon': Icons.description,
      'tooltip': 'Detailed Project Report',
    },
    {
      'title': 'Work',
      'icon': Icons.work,
      'tooltip': 'Work Process',
    },
    {
      'title': 'Monitoring',
      'icon': Icons.analytics,
      'tooltip': 'Project Monitoring',
    },
    {
      'title': 'Work Entry',
      'icon': Icons.edit_note,
      'tooltip': 'Work Entry Details',
    },
  ];

  bool _isCurrentScreenEditing() {
    switch (_selectedIndex) {
      case 0:
        return _dprKey.currentState?.isEditing ?? false;
      case 1:
        return _workKey.currentState?.isEditing ?? false;
      case 2:
        return _monitoringKey.currentState?.isEditing ?? false;
      case 3:
        return _workEntryKey.currentState?.isEditing ?? false;
      default:
        return false;
    }
  }

  void _toggleEdit() {
    setState(() {
      switch (_selectedIndex) {
        case 0:
          _dprKey.currentState?.setState(() {
            _dprKey.currentState!.isEditing = !_dprKey.currentState!.isEditing;
          });
          break;
        case 1:
          _workKey.currentState?.setState(() {
            _workKey.currentState!.isEditing = !_workKey.currentState!.isEditing;
          });
          break;
        case 2:
          _monitoringKey.currentState?.setState(() {
            _monitoringKey.currentState!.isEditing = !_monitoringKey.currentState!.isEditing;
          });
          break;
        case 3:
          _workEntryKey.currentState?.setState(() {
            _workEntryKey.currentState!.isEditing = !_workEntryKey.currentState!.isEditing;
          });
          break;
      }
    });
  }

  void _saveChanges() {
    switch (_selectedIndex) {
      case 0:
        _dprKey.currentState?.saveChanges();
        break;
      case 1:
        _workKey.currentState?.saveChanges();
        break;
      case 2:
        _monitoringKey.currentState?.saveChanges();
        break;
      case 3:
        _workEntryKey.currentState?.saveChanges();
        break;
    }
    setState(() {});
  }

  void _cancelEdit() {
    setState(() {
      switch (_selectedIndex) {
        case 0:
          _dprKey.currentState?.setState(() {
            _dprKey.currentState!.isEditing = false;
            _dprKey.currentState!.dprData = widget.project.dprData ?? DPRData();
            _dprKey.currentState!.broadScopeController.text =
                _dprKey.currentState!.dprData.broadScope ?? '';
          });
          break;
        case 1:
          _workKey.currentState?.setState(() {
            _workKey.currentState!.isEditing = false;
            _workKey.currentState!.workData = widget.project.workData ?? WorkData();
          });
          break;
        case 2:
          _monitoringKey.currentState?.setState(() {
            _monitoringKey.currentState!.isEditing = false;
            _monitoringKey.currentState!.monitoringData =
                widget.project.monitoringData ?? MonitoringData();
            _monitoringKey.currentState!.initializeControllers();
          });
          break;
        case 3:
          _workEntryKey.currentState?.setState(() {
            _workEntryKey.currentState!.isEditing = false;
            _workEntryKey.currentState!.expandedIndex = null;
            _workEntryKey.currentState!.initializeActivities();
          });
          break;
      }
    });
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return DPRScreen(key: _dprKey, project: widget.project);
      case 1:
        return WorkScreen(key: _workKey, project: widget.project);
      case 2:
        return MonitoringScreen(key: _monitoringKey, project: widget.project);
      case 3:
        return WorkEntryScreen(key: _workEntryKey, project: widget.project);
      default:
        return WorkScreen(key: _workKey, project: widget.project);
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isExpanded,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 8 : 4,
        vertical: 2,
      ),
      child: Material(
        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Tooltip(
            message: tooltip ?? label,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 16 : 8,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(currentTab['icon'], color: Colors.white),
            const SizedBox(width: 8),
            Text(currentTab['tooltip']),
          ],
        ),
        actions: [
          if (!_isCurrentScreenEditing())
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEdit,
              tooltip: 'Edit',
            ),
          if (_isCurrentScreenEditing()) ...[
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _cancelEdit,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
              tooltip: 'Save',
            ),
          ],
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(_isDrawerPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              setState(() {
                _isDrawerPinned = !_isDrawerPinned;
                _isDrawerExpanded = _isDrawerPinned;
              });
            },
            tooltip: _isDrawerPinned ? 'Unpin sidebar' : 'Pin sidebar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Collapsible Drawer
          MouseRegion(
            onEnter: (_) {
              if (!_isDrawerPinned) {
                setState(() {
                  _isDrawerExpanded = true;
                });
              }
            },
            onExit: (_) {
              if (!_isDrawerPinned) {
                setState(() {
                  _isDrawerExpanded = false;
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isDrawerExpanded ? 250 : 60,
              decoration: BoxDecoration(
                color: AppTheme.sidebarBackground,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxWidth: _isDrawerExpanded ? 250 : 60,
                  child: SizedBox(
                    width: _isDrawerExpanded ? 250 : 60,
                    child: Column(
                      children: [
                        // Project Info Section
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: _isDrawerExpanded ? 1.0 : 0.0,
                          child: _isDrawerExpanded
                              ? Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue.withOpacity(0.05),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppTheme.getCategoryColor(widget.project.category).withOpacity(0.2),
                                        child: Text(
                                          '${widget.project.srNo}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.getCategoryColor(widget.project.category),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 226),
                                        child: Text(
                                          widget.project.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 226),
                                        child: Text(
                                          '${widget.project.categoryName} • Cat ${widget.project.category}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 200),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppTheme.getStatusColor(widget.project.status).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppTheme.getStatusColor(widget.project.status),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.getStatusColor(widget.project.status),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  widget.project.status,
                                                  style: TextStyle(
                                                    color: AppTheme.getStatusColor(widget.project.status),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        if (!_isDrawerExpanded)
                          Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.getCategoryColor(widget.project.category).withOpacity(0.2),
                                child: Text(
                                  '${widget.project.srNo}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.getCategoryColor(widget.project.category),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Navigation Items
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            children: List.generate(_tabs.length, (index) {
                              final tab = _tabs[index];
                              return _buildDrawerItem(
                                icon: tab['icon'],
                                label: tab['title'],
                                isSelected: _selectedIndex == index,
                                isExpanded: _isDrawerExpanded,
                                tooltip: tab['tooltip'],
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }
}
