class WorkEntryActivity {
  String particulars;
  DateTime? startDate;
  int? periodDays;
  DateTime? endDate;
  String? personResponsible;
  String? postHeld;
  String? pendingWith;

  WorkEntryActivity({
    required this.particulars,
    this.startDate,
    this.periodDays,
    this.endDate,
    this.personResponsible,
    this.postHeld,
    this.pendingWith,
  });

  factory WorkEntryActivity.fromJson(Map<String, dynamic> json) {
    return WorkEntryActivity(
      particulars: json['particulars'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      periodDays: json['periodDays'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      personResponsible: json['personResponsible'],
      postHeld: json['postHeld'],
      pendingWith: json['pendingWith'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'particulars': particulars,
      'startDate': startDate?.toIso8601String(),
      'periodDays': periodDays,
      'endDate': endDate?.toIso8601String(),
      'personResponsible': personResponsible,
      'postHeld': postHeld,
      'pendingWith': pendingWith,
    };
  }

  bool get isCompleted => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isInProgress => startDate != null && (endDate == null || DateTime.now().isBefore(endDate!));
  bool get isPending => startDate == null;
}
