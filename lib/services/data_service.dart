import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/project.dart';
import '../utils/constants.dart';

class CategoryInfo {
  final String name;
  final String colorHex;
  final String iconName;

  CategoryInfo({
    required this.name,
    required this.colorHex,
    required this.iconName,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'colorHex': colorHex,
    'iconName': iconName,
  };

  factory CategoryInfo.fromJson(Map<String, dynamic> json) => CategoryInfo(
    name: json['name'],
    colorHex: json['colorHex'],
    iconName: json['iconName'],
  );
}

class DataService with ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;
  Map<String, CategoryInfo> _customCategories = {};

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, CategoryInfo> get customCategories => _customCategories;

  Future<void> loadProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String response = await rootBundle.loadString('assets/data/projects_data.json');
      final Map<String, dynamic> data = json.decode(response);

      _projects = (data['projects'] as List)
          .map((projectJson) => Project.fromJson(projectJson))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load projects: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Project> getProjectsByCategory(String category) {
    return _projects.where((p) => p.category == category).toList();
  }

  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _projects;

    final lowercaseQuery = query.toLowerCase();
    return _projects.where((p) {
      return p.name.toLowerCase().contains(lowercaseQuery) ||
             p.categoryName.toLowerCase().contains(lowercaseQuery) ||
             (p.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  List<Project> filterProjects({
    String? category,
    String? status,
    String? responsiblePerson,
  }) {
    return _projects.where((project) {
      if (category != null && category != 'All' && project.category != category) {
        return false;
      }
      if (status != null && status != 'All' && project.status != status) {
        return false;
      }
      return true;
    }).toList();
  }

  void updateProject(Project updatedProject) {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
  }

  void addProject(Project project) {
    final existingIndex = _projects.indexWhere((p) => p.id == project.id);
    if (existingIndex != -1) {
      // Update existing project
      _projects[existingIndex] = project;
    } else {
      // Add new project
      _projects.add(project);
    }
    notifyListeners();
    saveProjectsToLocal();
  }

  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
    saveProjectsToLocal();
  }

  void replaceAllProjects(List<Project> newProjects) {
    _projects = newProjects;
    notifyListeners();
    saveProjectsToLocal();
  }

  Future<void> saveProjectsToLocal() async {
    try {
      final jsonData = {
        'projects': _projects.map((p) => p.toJson()).toList(),
        'customCategories': _customCategories.map((key, value) => MapEntry(key, value.toJson())),
      };
      final jsonString = json.encode(jsonData);
      if (kDebugMode) {
        print('Projects saved: $jsonString');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving projects: $e');
      }
    }
  }

  void addCustomCategory(String code, CategoryInfo categoryInfo) {
    _customCategories[code] = categoryInfo;
    notifyListeners();
    saveProjectsToLocal();
  }

  void removeCustomCategory(String code) {
    _customCategories.remove(code);
    // Also remove all projects in this category
    _projects.removeWhere((p) => p.category == code);
    notifyListeners();
    saveProjectsToLocal();
  }

  Map<String, CategoryInfo> getAllCategories() {
    return {..._customCategories};
  }

  String getNextCategoryCode() {
    // Get all existing codes
    final existingCodes = {...AppConstants.categories.keys, ..._customCategories.keys}.toList();

    // Find the next available letter starting from F
    for (int i = 70; i <= 90; i++) { // ASCII codes for F-Z
      final code = String.fromCharCode(i);
      if (!existingCodes.contains(code)) {
        return code;
      }
    }

    // If all single letters are taken, use AA, AB, etc.
    return 'AA';
  }
}
