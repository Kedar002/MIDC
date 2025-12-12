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
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: AppTheme.sidebarBackground,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.05),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppTheme.getCategoryColor(widget.project.category).withOpacity(0.2),
                        child: Text(
                          '${widget.project.srNo}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getCategoryColor(widget.project.category),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.project.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.project.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.project.description!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final tab = _tabs[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Material(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Tooltip(
                              message: tab['tooltip'],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      tab['icon'],
                                      size: 20,
                                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        tab['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Progress',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: widget.project.overallProgress / 100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.getStatusColor(widget.project.status),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.project.overallProgress}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }
}
