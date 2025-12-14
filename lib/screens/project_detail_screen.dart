import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/dpr_data.dart';
import '../models/work_data.dart';
import '../models/monitoring_data.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../widgets/common_app_bar.dart';
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
  String _searchQuery = '';

  // GlobalKeys for accessing child screen states
  final GlobalKey<DPRScreenState> _dprKey = GlobalKey();
  final GlobalKey<WorkScreenState> _workKey = GlobalKey();
  final GlobalKey<MonitoringScreenState> _monitoringKey = GlobalKey();
  final GlobalKey<WorkEntryScreenState> _workEntryKey = GlobalKey();

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'DPR',
      'icon': Icons.description_outlined,
      'tooltip': 'Detailed Project Report',
    },
    {
      'title': 'Work',
      'icon': Icons.work_outline,
      'tooltip': 'Work Process',
    },
    {
      'title': 'Monitoring',
      'icon': Icons.analytics_outlined,
      'tooltip': 'Project Monitoring',
    },
    {
      'title': 'Work Entry',
      'icon': Icons.edit_note_outlined,
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
        return DPRScreen(key: _dprKey, project: widget.project, searchQuery: _searchQuery);
      case 1:
        return WorkScreen(key: _workKey, project: widget.project, searchQuery: _searchQuery);
      case 2:
        return MonitoringScreen(key: _monitoringKey, project: widget.project, searchQuery: _searchQuery);
      case 3:
        return WorkEntryScreen(key: _workEntryKey, project: widget.project, searchQuery: _searchQuery);
      default:
        return WorkScreen(key: _workKey, project: widget.project, searchQuery: _searchQuery);
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
        horizontal: isExpanded ? AppSpacing.sm : AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: Material(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Tooltip(
            message: tooltip ?? label,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? AppSpacing.lg : AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: AppSpacing.iconMd,
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                  ),
                  if (isExpanded) ...[
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.background : AppColors.textPrimary,
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
      appBar: CommonAppBar(
        title: currentTab['tooltip'],
        icon: currentTab['icon'],
        showEditButton: true,
        isEditing: _isCurrentScreenEditing(),
        onEditToggle: _toggleEdit,
        onSave: _saveChanges,
        onCancel: _cancelEdit,
        onPinToggle: () {
          setState(() {
            _isDrawerPinned = !_isDrawerPinned;
            _isDrawerExpanded = _isDrawerPinned;
          });
        },
        isPinned: _isDrawerPinned,
        showSearch: true,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
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
                color: AppColors.surface,
                border: Border(
                  right: BorderSide(color: AppColors.border),
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
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.05),
                                    border: Border(
                                      bottom: BorderSide(color: AppColors.border),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 226),
                                        child: Text(
                                          widget.project.name,
                                          style: AppTextStyles.labelSmall.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.xs),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 226),
                                        child: Text(
                                          '${widget.project.categoryName} • Cat ${widget.project.category}',
                                          style: AppTextStyles.captionSmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 200),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
                                            vertical: AppSpacing.xxs,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.getStatusColor(widget.project.status).withOpacity(0.2),
                                                AppTheme.getStatusColor(widget.project.status).withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                            border: Border.all(
                                              color: AppTheme.getStatusColor(widget.project.status).withOpacity(0.5),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.getStatusColor(widget.project.status),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppTheme.getStatusColor(widget.project.status).withOpacity(0.5),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: AppSpacing.xs),
                                              Flexible(
                                                child: Text(
                                                  widget.project.status,
                                                  style: AppTextStyles.captionSmall.copyWith(
                                                    color: AppTheme.getStatusColor(widget.project.status),
                                                    fontWeight: FontWeight.w700,
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
                              : const SizedBox(height: 97, width: 60), // Match expanded height
                        ),
                        // Navigation Items
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
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
