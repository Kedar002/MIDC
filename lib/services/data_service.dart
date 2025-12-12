import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/project.dart';

class DataService with ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  Future<void> saveProjectsToLocal() async {
    try {
      final jsonData = {
        'projects': _projects.map((p) => p.toJson()).toList(),
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
}
