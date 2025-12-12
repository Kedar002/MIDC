import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';

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
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search projects by name or category...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () => onSearchChanged(''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All', overflow: TextOverflow.ellipsis)),
                    ...AppConstants.categories.entries.map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text('${entry.key} - ${entry.value}', overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: onCategoryChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.flag, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(child: Text(status, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ).toList(),
                  onChanged: onStatusChanged,
                ),
              ),
              if (hasActiveFilters && onClearFilters != null) ...[
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
