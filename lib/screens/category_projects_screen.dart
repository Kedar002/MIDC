import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import '../widgets/search_filter_bar.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import 'project_detail_screen.dart';

class CategoryProjectsScreen extends StatefulWidget {
  final String categoryCode;
  final String categoryName;

  const CategoryProjectsScreen({
    super.key,
    required this.categoryCode,
    required this.categoryName,
  });

  @override
  State<CategoryProjectsScreen> createState() => _CategoryProjectsScreenState();
}

class _CategoryProjectsScreenState extends State<CategoryProjectsScreen> {
  String _searchQuery = '';
  String? _selectedStatus = 'All';

  Color _getCategoryColor() {
    switch (widget.categoryCode) {
      case 'A':
        return const Color(0xFF6366F1); // Indigo
      case 'B':
        return const Color(0xFF8B5CF6); // Purple
      case 'C':
        return const Color(0xFF06B6D4); // Cyan
      case 'D':
        return const Color(0xFF10B981); // Green
      case 'E':
        return const Color(0xFFF59E0B); // Amber
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.categoryCode) {
      case 'A':
        return Icons.festival_outlined;
      case 'B':
        return Icons.account_balance_outlined;
      case 'C':
        return Icons.location_city_outlined;
      case 'D':
        return Icons.route_outlined;
      case 'E':
        return Icons.work_outline;
      default:
        return Icons.folder_outlined;
    }
  }

  List<Project> _getFilteredProjects(List<Project> categoryProjects) {
    var filtered = categoryProjects;

    if (_searchQuery.isNotEmpty) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(lowercaseQuery) ||
               (p.description?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }

    if (_selectedStatus != null && _selectedStatus != 'All') {
      filtered = filtered.where((p) => p.status == _selectedStatus).toList();
    }

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedStatus = 'All';
    });
  }

  Future<void> _handleDeleteProject(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Project', style: AppTextStyles.h4),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textInverse,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final dataService = context.read<DataService>();
      dataService.deleteProject(project.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.name}" deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.categoryName, style: AppTextStyles.h5),
                  Text(
                    'Category ${widget.categoryCode}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final categoryProjects = dataService.projects
              .where((p) => p.category == widget.categoryCode)
              .toList();

          final filteredProjects = _getFilteredProjects(categoryProjects);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search projects...',
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: categoryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          icon: const Icon(
                            Icons.filter_list_outlined,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          style: AppTextStyles.body,
                          items: ['All', 'Pending', 'In Progress', 'Completed']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty || _selectedStatus != 'All') ...[
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        icon: const Icon(Icons.clear_outlined),
                        tooltip: 'Clear filters',
                        onPressed: _clearFilters,
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${filteredProjects.length} ${filteredProjects.length == 1 ? 'project' : 'projects'}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredProjects.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxxl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_outlined,
                                size: 64,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'No projects found',
                                style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                _searchQuery.isNotEmpty || _selectedStatus != 'All'
                                    ? 'Try adjusting your filters'
                                    : 'No projects in this category yet',
                                style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 240,
                          crossAxisSpacing: AppSpacing.lg,
                          mainAxisSpacing: AppSpacing.lg,
                        ),
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = filteredProjects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetailScreen(
                                    project: project,
                                  ),
                                ),
                              );
                            },
                            onDelete: () => _handleDeleteProject(project),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
