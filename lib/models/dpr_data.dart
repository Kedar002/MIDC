// Enum for workflow status (radio button options)
enum WorkflowStatus {
  notStarted,
  inProgress,
  completed,
  approved;

  String get displayName {
    switch (this) {
      case WorkflowStatus.notStarted:
        return 'Not started';
      case WorkflowStatus.inProgress:
        return 'In progress';
      case WorkflowStatus.completed:
        return 'Completed';
      case WorkflowStatus.approved:
        return 'Approved';
    }
  }

  static WorkflowStatus? fromString(String? value) {
    if (value == null) return null;
    return WorkflowStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => WorkflowStatus.notStarted,
    );
  }
}

class DPRData {
  // 1. Broad Scope of Work
  String? broadScope;

  // 2. Bid Document for DPR
  WorkflowStatus? bidDocDPRStatus;
  DateTime? bidDocDPRDate;

  // 3. Tender Invite
  DateTime? tenderInviteDate;

  // 4. No. of qualified bidders
  int? qualifiedBidders;

  // 5. Successful bidder name
  String? successfulBidderName;

  // 6. Prebid Meeting
  WorkflowStatus? prebidStatus;
  DateTime? prebidDate;

  // 7. CSD Replies (checkbox group - store as list of strings)
  List<String>? csdReplies;
  DateTime? csdDate;

  // 8. Bid Submit
  DateTime? bidSubmitDate;

  // 9. Financial Bid Opening
  DateTime? finBidDate;

  // 10. LOI (Letter of Intent)
  WorkflowStatus? loiStatus;
  DateTime? loiDate;

  // 11. LOA (Letter of Acceptance)
  WorkflowStatus? loaStatus;
  DateTime? loaDate;
  String? loaDelayReasons;

  // 12. PBG (Performance Bank Guarantee)
  DateTime? pbgDate;
  double? pbgAmount;
  int? pbgPeriodDays;

  // 13. Agreement
  WorkflowStatus? agreementStatus;
  DateTime? agreementDate;

  // 14. Work Order
  WorkflowStatus? workOrderStatus;
  DateTime? workOrderDate;

  // 15. Inception Report
  WorkflowStatus? inceptionReportStatus;
  DateTime? inceptionReportDate;

  // 16. Survey
  WorkflowStatus? surveyStatus;
  DateTime? surveyDate;
  String? surveyDelayReasons;

  // 17. Alignment & Layout
  WorkflowStatus? alignmentLayoutStatus;
  DateTime? alignmentLayoutDate;

  // 18. Draft DPR
  WorkflowStatus? draftDPRStatus;
  DateTime? draftDPRDate;

  // 19. Drawings
  WorkflowStatus? drawingsStatus;
  DateTime? drawingsDate;

  // 20. BOQ
  WorkflowStatus? boqStatus;
  DateTime? boqDate;

  // 21. Environmental Clearance
  WorkflowStatus? envClearanceStatus;
  DateTime? envClearanceDate;

  // 22. Cash Flow
  WorkflowStatus? cashFlowStatus;
  DateTime? cashFlowDate;

  // 23. LA Proposal
  WorkflowStatus? laProposalStatus;
  DateTime? laProposalDate;

  // 24. Utility Shifting
  WorkflowStatus? utilityShiftingStatus;
  DateTime? utilityShiftingDate;

  // 25. Final DPR
  WorkflowStatus? finalDPRStatus;
  DateTime? finalDPRDate;

  // 26. Bid Document for Work
  WorkflowStatus? bidDocWorkStatus;
  DateTime? bidDocWorkDate;

  // 27. Structures Tracking
  int? hpcNos;
  WorkflowStatus? hpcStatus;

  int? bridgesNos;
  WorkflowStatus? bridgesStatus;

  int? culvertsNos;
  WorkflowStatus? culvertsStatus;

  int? vupNos;
  WorkflowStatus? vupStatus;

  int? rorNos;
  WorkflowStatus? rorStatus;

  int? minorBridgesNos;
  WorkflowStatus? minorBridgesStatus;

  int? causeWayNos;
  WorkflowStatus? causeWayStatus;

  // 28. Flyover
  double? flyoverLengthMeters;
  WorkflowStatus? flyoverStatus;

  DPRData({
    this.broadScope,
    this.bidDocDPRStatus,
    this.bidDocDPRDate,
    this.tenderInviteDate,
    this.qualifiedBidders,
    this.successfulBidderName,
    this.prebidStatus,
    this.prebidDate,
    this.csdReplies,
    this.csdDate,
    this.bidSubmitDate,
    this.finBidDate,
    this.loiStatus,
    this.loiDate,
    this.loaStatus,
    this.loaDate,
    this.loaDelayReasons,
    this.pbgDate,
    this.pbgAmount,
    this.pbgPeriodDays,
    this.agreementStatus,
    this.agreementDate,
    this.workOrderStatus,
    this.workOrderDate,
    this.inceptionReportStatus,
    this.inceptionReportDate,
    this.surveyStatus,
    this.surveyDate,
    this.surveyDelayReasons,
    this.alignmentLayoutStatus,
    this.alignmentLayoutDate,
    this.draftDPRStatus,
    this.draftDPRDate,
    this.drawingsStatus,
    this.drawingsDate,
    this.boqStatus,
    this.boqDate,
    this.envClearanceStatus,
    this.envClearanceDate,
    this.cashFlowStatus,
    this.cashFlowDate,
    this.laProposalStatus,
    this.laProposalDate,
    this.utilityShiftingStatus,
    this.utilityShiftingDate,
    this.finalDPRStatus,
    this.finalDPRDate,
    this.bidDocWorkStatus,
    this.bidDocWorkDate,
    this.hpcNos,
    this.hpcStatus,
    this.bridgesNos,
    this.bridgesStatus,
    this.culvertsNos,
    this.culvertsStatus,
    this.vupNos,
    this.vupStatus,
    this.rorNos,
    this.rorStatus,
    this.minorBridgesNos,
    this.minorBridgesStatus,
    this.causeWayNos,
    this.causeWayStatus,
    this.flyoverLengthMeters,
    this.flyoverStatus,
  });

  factory DPRData.fromJson(Map<String, dynamic> json) {
    return DPRData(
      broadScope: json['broadScope'],
      bidDocDPRStatus: WorkflowStatus.fromString(json['bidDocDPRStatus']),
      bidDocDPRDate: json['bidDocDPRDate'] != null ? DateTime.parse(json['bidDocDPRDate']) : null,
      tenderInviteDate: json['tenderInviteDate'] != null ? DateTime.parse(json['tenderInviteDate']) : null,
      qualifiedBidders: json['qualifiedBidders'],
      successfulBidderName: json['successfulBidderName'],
      prebidStatus: WorkflowStatus.fromString(json['prebidStatus']),
      prebidDate: json['prebidDate'] != null ? DateTime.parse(json['prebidDate']) : null,
      csdReplies: json['csdReplies'] != null ? List<String>.from(json['csdReplies']) : null,
      csdDate: json['csdDate'] != null ? DateTime.parse(json['csdDate']) : null,
      bidSubmitDate: json['bidSubmitDate'] != null ? DateTime.parse(json['bidSubmitDate']) : null,
      finBidDate: json['finBidDate'] != null ? DateTime.parse(json['finBidDate']) : null,
      loiStatus: WorkflowStatus.fromString(json['loiStatus']),
      loiDate: json['loiDate'] != null ? DateTime.parse(json['loiDate']) : null,
      loaStatus: WorkflowStatus.fromString(json['loaStatus']),
      loaDate: json['loaDate'] != null ? DateTime.parse(json['loaDate']) : null,
      loaDelayReasons: json['loaDelayReasons'],
      pbgDate: json['pbgDate'] != null ? DateTime.parse(json['pbgDate']) : null,
      pbgAmount: json['pbgAmount']?.toDouble(),
      pbgPeriodDays: json['pbgPeriodDays'],
      agreementStatus: WorkflowStatus.fromString(json['agreementStatus']),
      agreementDate: json['agreementDate'] != null ? DateTime.parse(json['agreementDate']) : null,
      workOrderStatus: WorkflowStatus.fromString(json['workOrderStatus']),
      workOrderDate: json['workOrderDate'] != null ? DateTime.parse(json['workOrderDate']) : null,
      inceptionReportStatus: WorkflowStatus.fromString(json['inceptionReportStatus']),
      inceptionReportDate: json['inceptionReportDate'] != null ? DateTime.parse(json['inceptionReportDate']) : null,
      surveyStatus: WorkflowStatus.fromString(json['surveyStatus']),
      surveyDate: json['surveyDate'] != null ? DateTime.parse(json['surveyDate']) : null,
      surveyDelayReasons: json['surveyDelayReasons'],
      alignmentLayoutStatus: WorkflowStatus.fromString(json['alignmentLayoutStatus']),
      alignmentLayoutDate: json['alignmentLayoutDate'] != null ? DateTime.parse(json['alignmentLayoutDate']) : null,
      draftDPRStatus: WorkflowStatus.fromString(json['draftDPRStatus']),
      draftDPRDate: json['draftDPRDate'] != null ? DateTime.parse(json['draftDPRDate']) : null,
      drawingsStatus: WorkflowStatus.fromString(json['drawingsStatus']),
      drawingsDate: json['drawingsDate'] != null ? DateTime.parse(json['drawingsDate']) : null,
      boqStatus: WorkflowStatus.fromString(json['boqStatus']),
      boqDate: json['boqDate'] != null ? DateTime.parse(json['boqDate']) : null,
      envClearanceStatus: WorkflowStatus.fromString(json['envClearanceStatus']),
      envClearanceDate: json['envClearanceDate'] != null ? DateTime.parse(json['envClearanceDate']) : null,
      cashFlowStatus: WorkflowStatus.fromString(json['cashFlowStatus']),
      cashFlowDate: json['cashFlowDate'] != null ? DateTime.parse(json['cashFlowDate']) : null,
      laProposalStatus: WorkflowStatus.fromString(json['laProposalStatus']),
      laProposalDate: json['laProposalDate'] != null ? DateTime.parse(json['laProposalDate']) : null,
      utilityShiftingStatus: WorkflowStatus.fromString(json['utilityShiftingStatus']),
      utilityShiftingDate: json['utilityShiftingDate'] != null ? DateTime.parse(json['utilityShiftingDate']) : null,
      finalDPRStatus: WorkflowStatus.fromString(json['finalDPRStatus']),
      finalDPRDate: json['finalDPRDate'] != null ? DateTime.parse(json['finalDPRDate']) : null,
      bidDocWorkStatus: WorkflowStatus.fromString(json['bidDocWorkStatus']),
      bidDocWorkDate: json['bidDocWorkDate'] != null ? DateTime.parse(json['bidDocWorkDate']) : null,
      hpcNos: json['hpcNos'],
      hpcStatus: WorkflowStatus.fromString(json['hpcStatus']),
      bridgesNos: json['bridgesNos'],
      bridgesStatus: WorkflowStatus.fromString(json['bridgesStatus']),
      culvertsNos: json['culvertsNos'],
      culvertsStatus: WorkflowStatus.fromString(json['culvertsStatus']),
      vupNos: json['vupNos'],
      vupStatus: WorkflowStatus.fromString(json['vupStatus']),
      rorNos: json['rorNos'],
      rorStatus: WorkflowStatus.fromString(json['rorStatus']),
      minorBridgesNos: json['minorBridgesNos'],
      minorBridgesStatus: WorkflowStatus.fromString(json['minorBridgesStatus']),
      causeWayNos: json['causeWayNos'],
      causeWayStatus: WorkflowStatus.fromString(json['causeWayStatus']),
      flyoverLengthMeters: json['flyoverLengthMeters']?.toDouble(),
      flyoverStatus: WorkflowStatus.fromString(json['flyoverStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'broadScope': broadScope,
      'bidDocDPRStatus': bidDocDPRStatus?.name,
      'bidDocDPRDate': bidDocDPRDate?.toIso8601String(),
      'tenderInviteDate': tenderInviteDate?.toIso8601String(),
      'qualifiedBidders': qualifiedBidders,
      'successfulBidderName': successfulBidderName,
      'prebidStatus': prebidStatus?.name,
      'prebidDate': prebidDate?.toIso8601String(),
      'csdReplies': csdReplies,
      'csdDate': csdDate?.toIso8601String(),
      'bidSubmitDate': bidSubmitDate?.toIso8601String(),
      'finBidDate': finBidDate?.toIso8601String(),
      'loiStatus': loiStatus?.name,
      'loiDate': loiDate?.toIso8601String(),
      'loaStatus': loaStatus?.name,
      'loaDate': loaDate?.toIso8601String(),
      'loaDelayReasons': loaDelayReasons,
      'pbgDate': pbgDate?.toIso8601String(),
      'pbgAmount': pbgAmount,
      'pbgPeriodDays': pbgPeriodDays,
      'agreementStatus': agreementStatus?.name,
      'agreementDate': agreementDate?.toIso8601String(),
      'workOrderStatus': workOrderStatus?.name,
      'workOrderDate': workOrderDate?.toIso8601String(),
      'inceptionReportStatus': inceptionReportStatus?.name,
      'inceptionReportDate': inceptionReportDate?.toIso8601String(),
      'surveyStatus': surveyStatus?.name,
      'surveyDate': surveyDate?.toIso8601String(),
      'surveyDelayReasons': surveyDelayReasons,
      'alignmentLayoutStatus': alignmentLayoutStatus?.name,
      'alignmentLayoutDate': alignmentLayoutDate?.toIso8601String(),
      'draftDPRStatus': draftDPRStatus?.name,
      'draftDPRDate': draftDPRDate?.toIso8601String(),
      'drawingsStatus': drawingsStatus?.name,
      'drawingsDate': drawingsDate?.toIso8601String(),
      'boqStatus': boqStatus?.name,
      'boqDate': boqDate?.toIso8601String(),
      'envClearanceStatus': envClearanceStatus?.name,
      'envClearanceDate': envClearanceDate?.toIso8601String(),
      'cashFlowStatus': cashFlowStatus?.name,
      'cashFlowDate': cashFlowDate?.toIso8601String(),
      'laProposalStatus': laProposalStatus?.name,
      'laProposalDate': laProposalDate?.toIso8601String(),
      'utilityShiftingStatus': utilityShiftingStatus?.name,
      'utilityShiftingDate': utilityShiftingDate?.toIso8601String(),
      'finalDPRStatus': finalDPRStatus?.name,
      'finalDPRDate': finalDPRDate?.toIso8601String(),
      'bidDocWorkStatus': bidDocWorkStatus?.name,
      'bidDocWorkDate': bidDocWorkDate?.toIso8601String(),
      'hpcNos': hpcNos,
      'hpcStatus': hpcStatus?.name,
      'bridgesNos': bridgesNos,
      'bridgesStatus': bridgesStatus?.name,
      'culvertsNos': culvertsNos,
      'culvertsStatus': culvertsStatus?.name,
      'vupNos': vupNos,
      'vupStatus': vupStatus?.name,
      'rorNos': rorNos,
      'rorStatus': rorStatus?.name,
      'minorBridgesNos': minorBridgesNos,
      'minorBridgesStatus': minorBridgesStatus?.name,
      'causeWayNos': causeWayNos,
      'causeWayStatus': causeWayStatus?.name,
      'flyoverLengthMeters': flyoverLengthMeters,
      'flyoverStatus': flyoverStatus?.name,
    };
  }

  int getCompletionPercentage() {
    // Count completed workflow statuses
    final statusFields = [
      bidDocDPRStatus,
      prebidStatus,
      loiStatus,
      loaStatus,
      agreementStatus,
      workOrderStatus,
      inceptionReportStatus,
      surveyStatus,
      alignmentLayoutStatus,
      draftDPRStatus,
      drawingsStatus,
      boqStatus,
      envClearanceStatus,
      cashFlowStatus,
      laProposalStatus,
      utilityShiftingStatus,
      finalDPRStatus,
      bidDocWorkStatus,
    ];

    final completed = statusFields.where((status) =>
      status == WorkflowStatus.completed || status == WorkflowStatus.approved
    ).length;

    return ((completed / statusFields.length) * 100).round();
  }
}
