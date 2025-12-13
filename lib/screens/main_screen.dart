import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import '../widgets/search_filter_bar.dart';
import '../utils/constants.dart';
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
        // Load from local storage
        if (mounted) {
          context.read<DataService>().loadProjects();
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
        title: const Text('Connect Google Sheet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Before connecting, publish your sheet to web:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Open your Google Sheet\n'
                '2. Go to File → Share → Publish to web\n'
                '3. Select "Entire Document" + CSV format\n'
                '4. Click "Publish"',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text('Then paste your Google Sheets URL:'),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'https://docs.google.com/spreadsheets/d/...',
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
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection failed: $e'),
              backgroundColor: Colors.red,
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
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
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
        title: const Text('Disconnect Google Sheet'),
        content: const Text('Are you sure you want to disconnect from this Google Sheet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _sheetsService.disconnectSheet();
      setState(() {
        _connectedSheetUrl = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disconnected from Google Sheet'),
            backgroundColor: Colors.orange,
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
            Text(AppConstants.appName),
            Text(
              AppConstants.appFullName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          if (dataService.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading projects...'),
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
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${dataService.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No projects found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
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
