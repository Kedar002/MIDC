import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';
import '../utils/constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../widgets/category_card.dart';
import 'category_projects_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSheetsService _sheetsService = GoogleSheetsService();
  bool _isConnecting = false;
  bool _isSyncing = false;
  String? _connectedSheetUrl;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if Google Sheet is connected
      final sheetUrl = await _sheetsService.getConnectedSheetUrl();
      if (sheetUrl != null && mounted) {
        setState(() {
          _connectedSheetUrl = sheetUrl;
        });
        // Sync from Google Sheets
        await _syncFromGoogleSheets();
      } else {
        // No sheet connected - start with empty projects
        if (mounted) {
          context.read<DataService>().replaceAllProjects([]);
        }
      }
    });
  }

  Future<void> _handleConnectSheet() async {
    // Show dialog to enter Google Sheet URL
    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect Google Sheet', style: AppTextStyles.h4),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share your Google Sheet:',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '1. Open your Google Sheet\n'
                '2. Click "Share" button (top right)\n'
                '3. Under "General access" select:\n'
                '   "Anyone with the link" + "Viewer"\n'
                '4. Click "Done"\n'
                '5. Copy the URL from browser address bar',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Then paste your Google Sheets URL:', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: controller,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'https://docs.google.com/spreadsheets/d/.../edit...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Connect'),
          ),
        ],
      ),
    );

    if (result == true && controller.text.isNotEmpty) {
      setState(() {
        _isConnecting = true;
      });

      try {
        // Save sheet connection
        await _sheetsService.saveSheetConnection(controller.text);

        // Sync data
        await _syncFromGoogleSheets();

        setState(() {
          _connectedSheetUrl = controller.text;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully connected to Google Sheet'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection failed: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isConnecting = false;
          });
        }
      }
    }
  }

  Future<void> _syncFromGoogleSheets() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      final projects = await _sheetsService.syncFromGoogleSheets();

      if (projects.isNotEmpty && mounted) {
        final dataService = context.read<DataService>();
        dataService.replaceAllProjects(projects);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Synced ${projects.length} projects from Google Sheet'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _handleDisconnectSheet() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disconnect Google Sheet', style: AppTextStyles.h4),
        content: Text('Are you sure you want to disconnect from this Google Sheet?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _sheetsService.disconnectSheet();

      // Clear all projects from DataService
      if (mounted) {
        context.read<DataService>().replaceAllProjects([]);
      }

      setState(() {
        _connectedSheetUrl = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disconnected from Google Sheet and cleared all data'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }

  Map<String, int> _getCategoryCounts(List<dynamic> projects) {
    final dataService = context.read<DataService>();
    final allCategoryCodes = {
      ...AppConstants.categories.keys,
      ...dataService.customCategories.keys,
    };
    final counts = <String, int>{};
    for (var category in allCategoryCodes) {
      counts[category] = projects.where((p) => p.category == category).length;
    }
    return counts;
  }

  List<String> _getFilteredCategories() {
    final dataService = context.read<DataService>();
    final allCategoryNames = {
      ...AppConstants.categories,
      ...dataService.customCategories.map((key, value) => MapEntry(key, value.name)),
    };

    if (_searchQuery.isEmpty) {
      return allCategoryNames.keys.toList();
    }

    final lowercaseQuery = _searchQuery.toLowerCase();
    return allCategoryNames.keys.where((categoryCode) {
      final categoryName = allCategoryNames[categoryCode]!;
      return categoryName.toLowerCase().contains(lowercaseQuery) ||
             categoryCode.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'work_outline':
        return Icons.work_outline;
      case 'festival_outlined':
        return Icons.festival_outlined;
      case 'account_balance_outlined':
        return Icons.account_balance_outlined;
      case 'location_city_outlined':
        return Icons.location_city_outlined;
      case 'route_outlined':
        return Icons.route_outlined;
      case 'build_outlined':
        return Icons.build_outlined;
      case 'business_outlined':
        return Icons.business_outlined;
      case 'apartment_outlined':
        return Icons.apartment_outlined;
      case 'construction_outlined':
        return Icons.construction_outlined;
      case 'engineering_outlined':
        return Icons.engineering_outlined;
      case 'factory_outlined':
        return Icons.factory_outlined;
      case 'home_work_outlined':
        return Icons.home_work_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  Future<void> _handleAddCategory() async {
    await showDialog(
      context: context,
      builder: (context) => _AddCategoryDialog(),
    );
  }

  Future<void> _handleDeleteCategory(String categoryCode, String categoryName) async {
    final dataService = context.read<DataService>();
    final projectsInCategory = dataService.projects
        .where((p) => p.category == categoryCode)
        .length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category', style: AppTextStyles.h4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete the category "$categoryName"?',
              style: AppTextStyles.body,
            ),
            if (projectsInCategory > 0) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'This will also delete $projectsInCategory ${projectsInCategory == 1 ? 'project' : 'projects'} in this category.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.warningDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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
      dataService.removeCustomCategory(categoryCode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$categoryName" deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.business_outlined,
                color: AppColors.textInverse,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppConstants.appName, style: AppTextStyles.h5),
                Text(
                  AppConstants.appFullName,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_connectedSheetUrl == null)
            IconButton(
              icon: _isConnecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                      ),
                    )
                  : const Icon(Icons.cable_outlined),
              tooltip: 'Connect Google Sheet',
              onPressed: _isConnecting ? null : _handleConnectSheet,
            ),
          if (_connectedSheetUrl != null) ...[
            IconButton(
              icon: _isSyncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                      ),
                    )
                  : const Icon(Icons.sync_outlined),
              tooltip: 'Sync from Google Sheet',
              onPressed: _isSyncing ? null : _syncFromGoogleSheets,
            ),
            IconButton(
              icon: const Icon(Icons.link_off_outlined),
              tooltip: 'Disconnect Google Sheet',
              onPressed: _handleDisconnectSheet,
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          if (dataService.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Loading projects...', style: AppTextStyles.body),
                ],
              ),
            );
          }

          if (dataService.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Error: ${dataService.error}',
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () => dataService.loadProjects(),
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final categoryCounts = _getCategoryCounts(dataService.projects);
          final totalProjects = dataService.projects.length;
          final filteredCategories = _getFilteredCategories();
          final totalCategories = AppConstants.categories.length + dataService.customCategories.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Project Categories',
                                style: AppTextStyles.h4.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xl),
                              Text(
                                '$totalProjects total projects across $totalCategories categories',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _handleAddCategory,
                          icon: const Icon(Icons.add_outlined, size: 18),
                          label: const Text('New Category'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textInverse,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
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
                          borderSide: const BorderSide(
                            color: AppColors.primary,
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
                  ],
                ),
              ),
              Expanded(
                child: totalProjects == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxxl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _connectedSheetUrl == null ? Icons.cloud_off_outlined : Icons.folder_outlined,
                                size: 64,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                _connectedSheetUrl == null
                                    ? 'No Google Sheet Connected'
                                    : 'No projects found',
                                style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                _connectedSheetUrl == null
                                    ? 'Click the link icon above to connect your Google Sheet'
                                    : 'Sync your sheet to load projects',
                                style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredCategories.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xxxl),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off_outlined,
                                    size: 64,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    'No categories found',
                                    style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Try a different search term',
                                    style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350,
                              mainAxisExtent: 200,
                              crossAxisSpacing: AppSpacing.lg,
                              mainAxisSpacing: AppSpacing.lg,
                            ),
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final categoryCode = filteredCategories[index];
                              final categoryName = AppConstants.categories[categoryCode] ??
                                  dataService.customCategories[categoryCode]?.name ??
                                  'Unknown';
                              final projectCount = categoryCounts[categoryCode] ?? 0;

                              // Get custom color and icon if it's a custom category
                              Color? customColor;
                              IconData? customIcon;
                              final isCustomCategory = dataService.customCategories.containsKey(categoryCode);
                              if (isCustomCategory) {
                                final categoryInfo = dataService.customCategories[categoryCode]!;
                                customColor = Color(int.parse(categoryInfo.colorHex.substring(1), radix: 16) + 0xFF000000);
                                // Map icon name to IconData
                                customIcon = _getIconFromName(categoryInfo.iconName);
                              }

                              return CategoryCard(
                                categoryCode: categoryCode,
                                categoryName: categoryName,
                                projectCount: projectCount,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryProjectsScreen(
                                        categoryCode: categoryCode,
                                        categoryName: categoryName,
                                      ),
                                    ),
                                  );
                                },
                                customColor: customColor,
                                customIcon: customIcon,
                                onDelete: isCustomCategory
                                    ? () => _handleDeleteCategory(categoryCode, categoryName)
                                    : null,
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

class _AddCategoryDialog extends StatefulWidget {
  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final nameController = TextEditingController();
  String selectedColor = '#6366F1';
  String selectedIcon = 'work_outline';

  final availableColors = [
    {'name': 'Indigo', 'hex': '#6366F1'},
    {'name': 'Purple', 'hex': '#8B5CF6'},
    {'name': 'Cyan', 'hex': '#06B6D4'},
    {'name': 'Green', 'hex': '#10B981'},
    {'name': 'Amber', 'hex': '#F59E0B'},
    {'name': 'Pink', 'hex': '#EC4899'},
    {'name': 'Red', 'hex': '#EF4444'},
    {'name': 'Blue', 'hex': '#3B82F6'},
    {'name': 'Emerald', 'hex': '#10B981'},
    {'name': 'Orange', 'hex': '#F97316'},
  ];

  final availableIcons = [
    {'name': 'work_outline', 'icon': Icons.work_outline},
    {'name': 'festival_outlined', 'icon': Icons.festival_outlined},
    {'name': 'account_balance_outlined', 'icon': Icons.account_balance_outlined},
    {'name': 'location_city_outlined', 'icon': Icons.location_city_outlined},
    {'name': 'route_outlined', 'icon': Icons.route_outlined},
    {'name': 'build_outlined', 'icon': Icons.build_outlined},
    {'name': 'business_outlined', 'icon': Icons.business_outlined},
    {'name': 'apartment_outlined', 'icon': Icons.apartment_outlined},
    {'name': 'construction_outlined', 'icon': Icons.construction_outlined},
    {'name': 'engineering_outlined', 'icon': Icons.engineering_outlined},
    {'name': 'factory_outlined', 'icon': Icons.factory_outlined},
    {'name': 'home_work_outlined', 'icon': Icons.home_work_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon( 
                      Icons.add_outlined,
                      color: AppColors.textInverse,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Add New Category', style: AppTextStyles.h4),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Category Name', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Special Projects',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Border Color', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: availableColors.map((colorData) {
                  final isSelected = selectedColor == colorData['hex'] as String?;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedColor = colorData['hex']! as String;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(int.parse((colorData['hex']! as String).substring(1), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.textPrimary : AppColors.border,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 24)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Icon', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: AppSpacing.xs,
                    crossAxisSpacing: AppSpacing.xs,
                  ),
                  itemCount: availableIcons.length,
                  itemBuilder: (context, index) {
                    final iconData = availableIcons[index];
                    final isSelected = selectedIcon == iconData['name'] as String?;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIcon = iconData['name']! as String;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(int.parse(selectedColor.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Color(int.parse(selectedColor.substring(1), radix: 16) + 0xFF000000)
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          iconData['icon'] as IconData,
                          color: isSelected
                              ? Color(int.parse(selectedColor.substring(1), radix: 16) + 0xFF000000)
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a category name'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      final dataService = context.read<DataService>();
                      final code = dataService.getNextCategoryCode();

                      dataService.addCustomCategory(
                        code,
                        CategoryInfo(
                          name: nameController.text,
                          colorHex: selectedColor,
                          iconName: selectedIcon,
                        ),
                      );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "${nameController.text}" added successfully'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    child: const Text('Add Category'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
