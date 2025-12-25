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
    final counts = <String, int>{};
    for (var category in AppConstants.categories.keys) {
      counts[category] = projects.where((p) => p.category == category).length;
    }
    return counts;
  }

  List<String> _getFilteredCategories() {
    if (_searchQuery.isEmpty) {
      return AppConstants.categories.keys.toList();
    }

    final lowercaseQuery = _searchQuery.toLowerCase();
    return AppConstants.categories.keys.where((categoryCode) {
      final categoryName = AppConstants.categories[categoryCode]!;
      return categoryName.toLowerCase().contains(lowercaseQuery) ||
             categoryCode.toLowerCase().contains(lowercaseQuery);
    }).toList();
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
                                '$totalProjects total projects across ${AppConstants.categories.length} categories',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
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
                              final categoryName = AppConstants.categories[categoryCode]!;
                              final projectCount = categoryCounts[categoryCode] ?? 0;

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
