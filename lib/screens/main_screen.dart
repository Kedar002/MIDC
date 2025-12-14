import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import '../widgets/search_filter_bar.dart';
import '../utils/constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import 'project_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _searchQuery = '';
  String? _selectedCategory = 'All';
  String? _selectedStatus = 'All';
  final GoogleSheetsService _sheetsService = GoogleSheetsService();
  bool _isConnecting = false;
  bool _isSyncing = false;
  String? _connectedSheetUrl;

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


  List<Project> _getFilteredProjects(List<Project> allProjects) {
    var filtered = allProjects;

    if (_searchQuery.isNotEmpty) {
      filtered = context.read<DataService>().searchProjects(_searchQuery);
    }

    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_selectedStatus != null && _selectedStatus != 'All') {
      filtered = filtered.where((p) => p.status == _selectedStatus).toList();
    }

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _selectedStatus = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.appName, style: AppTextStyles.h5),
            Text(
              AppConstants.appFullName,
              style: AppTextStyles.caption,
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
                  : const Icon(Icons.link),
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
                  : const Icon(Icons.sync),
              tooltip: 'Sync from Google Sheet',
              onPressed: _isSyncing ? null : _syncFromGoogleSheets,
            ),
            IconButton(
              icon: const Icon(Icons.link_off),
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
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filteredProjects = _getFilteredProjects(dataService.projects);

          return Column(
            children: [
              SearchFilterBar(
                searchQuery: _searchQuery,
                selectedCategory: _selectedCategory,
                selectedStatus: _selectedStatus,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onCategoryChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                onStatusChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                onClearFilters: _clearFilters,
              ),
              const Divider(height: 1),
              Expanded(
                child: filteredProjects.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxxl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _connectedSheetUrl == null ? Icons.cloud_off : Icons.folder_open,
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
                                    : 'Try adjusting your filters or sync your sheet',
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
