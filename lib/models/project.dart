import 'dpr_data.dart';
import 'work_data.dart';
import 'monitoring_data.dart';
import 'work_entry_data.dart';
import '../utils/constants.dart';

class Project {
  final String id;
  final String category;
  final int srNo;
  final String name;
  final String? description;
  DPRData? dprData;
  WorkData? workData;
  MonitoringData? monitoringData;
  List<WorkEntryActivity>? workEntryActivities;

  Project({
    required this.id,
    required this.category,
    required this.srNo,
    required this.name,
    this.description,
    this.dprData,
    this.workData,
    this.monitoringData,
    this.workEntryActivities,
  });

  String get categoryName => AppConstants.categories[category] ?? 'Unknown';

  String get status {
    final dprProgress = dprData?.getCompletionPercentage() ?? 0;
    final workProgress = workData?.getCompletionPercentage() ?? 0;
    final avgProgress = (dprProgress + workProgress) / 2;

    if (avgProgress == 0) return AppConstants.statusPending;
    if (avgProgress == 100) return AppConstants.statusCompleted;
    return AppConstants.statusInProgress;
  }

  int get overallProgress {
    final dprProgress = dprData?.getCompletionPercentage() ?? 0;
    final workProgress = workData?.getCompletionPercentage() ?? 0;
    return ((dprProgress + workProgress) / 2).round();
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      category: json['category'],
      srNo: json['srNo'],
      name: json['name'],
      description: json['description'],
      dprData: json['dprData'] != null ? DPRData.fromJson(json['dprData']) : null,
      workData: json['workData'] != null ? WorkData.fromJson(json['workData']) : null,
      monitoringData: json['monitoringData'] != null
          ? MonitoringData.fromJson(json['monitoringData'])
          : null,
      workEntryActivities: json['workEntryActivities'] != null
          ? (json['workEntryActivities'] as List)
              .map((a) => WorkEntryActivity.fromJson(a))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'srNo': srNo,
      'name': name,
      'description': description,
      'dprData': dprData?.toJson(),
      'workData': workData?.toJson(),
      'monitoringData': monitoringData?.toJson(),
      'workEntryActivities': workEntryActivities?.map((a) => a.toJson()).toList(),
    };
  }
}
