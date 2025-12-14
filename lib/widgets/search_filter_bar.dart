import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback? onClearFilters;

  const SearchFilterBar({
    super.key,
    required this.searchQuery,
    this.selectedCategory,
    this.selectedStatus,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        (selectedCategory != null && selectedCategory != 'All') ||
        (selectedStatus != null && selectedStatus != 'All') ||
        searchQuery.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: onSearchChanged,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Search projects by name or category...',
                    prefixIcon: const Icon(Icons.search_outlined, size: AppSpacing.iconMd),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: AppSpacing.iconMd),
                            onPressed: () => onSearchChanged(''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: AppTextStyles.label,
                    prefixIcon: const Icon(Icons.folder_outlined, size: AppSpacing.iconMd),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('All', style: AppTextStyles.body, overflow: TextOverflow.ellipsis),
                    ),
                    ...AppConstants.categories.entries.map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          '${entry.key} - ${entry.value}',
                          style: AppTextStyles.body,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onCategoryChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: AppTextStyles.label,
                    prefixIcon: const Icon(Icons.outlined_flag, size: AppSpacing.iconMd),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
                  ),
                  items: AppConstants.projectStatuses.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          if (status != 'All')
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppTheme.getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              status,
                              style: AppTextStyles.body,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                  onChanged: onStatusChanged,
                ),
              ),
              if (hasActiveFilters && onClearFilters != null) ...[
                const SizedBox(width: AppSpacing.md),
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all_outlined),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
