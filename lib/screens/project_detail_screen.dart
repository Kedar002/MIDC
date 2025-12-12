import 'package:flutter/material.dart';
import '../models/project.dart';
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

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return DPRScreen(project: widget.project);
      case 1:
        return WorkScreen(project: widget.project);
      case 2:
        return MonitoringScreen(project: widget.project);
      case 3:
        return WorkEntryScreen(project: widget.project);
      default:
        return WorkScreen(project: widget.project);
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Tooltip(
            message: tooltip ?? label,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.project.name),
            Text(
              '${widget.project.categoryName} • Category ${widget.project.category}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
            ),
          ],
        ),
        actions: [
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.getStatusColor(widget.project.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.getStatusColor(widget.project.status),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusColor(widget.project.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.project.status,
                  style: TextStyle(
                    color: AppTheme.getStatusColor(widget.project.status),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
              width: _isDrawerExpanded ? 220 : 60,
              decoration: BoxDecoration(
                color: AppTheme.sidebarBackground,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(_tabs.length, (index) {
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
                ],
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
