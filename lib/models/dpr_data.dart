class DPRData {
  String? broadScope;
  DateTime? bidDocDPR;
  DateTime? tenderInvite;
  DateTime? prebid;
  DateTime? csd;
  DateTime? bidSubmit;
  DateTime? workOrder;
  DateTime? inceptionReport;
  DateTime? survey;
  DateTime? alignmentLayout;
  DateTime? draftDPR;
  DateTime? drawings;
  DateTime? boq;
  DateTime? envClearance;
  DateTime? cashFlow;
  DateTime? laProposal;
  DateTime? utilityShifting;
  DateTime? finalDPR;
  DateTime? bidDocWork;

  DPRData({
    this.broadScope,
    this.bidDocDPR,
    this.tenderInvite,
    this.prebid,
    this.csd,
    this.bidSubmit,
    this.workOrder,
    this.inceptionReport,
    this.survey,
    this.alignmentLayout,
    this.draftDPR,
    this.drawings,
    this.boq,
    this.envClearance,
    this.cashFlow,
    this.laProposal,
    this.utilityShifting,
    this.finalDPR,
    this.bidDocWork,
  });

  factory DPRData.fromJson(Map<String, dynamic> json) {
    return DPRData(
      broadScope: json['broadScope'],
      bidDocDPR: json['bidDocDPR'] != null ? DateTime.parse(json['bidDocDPR']) : null,
      tenderInvite: json['tenderInvite'] != null ? DateTime.parse(json['tenderInvite']) : null,
      prebid: json['prebid'] != null ? DateTime.parse(json['prebid']) : null,
      csd: json['csd'] != null ? DateTime.parse(json['csd']) : null,
      bidSubmit: json['bidSubmit'] != null ? DateTime.parse(json['bidSubmit']) : null,
      workOrder: json['workOrder'] != null ? DateTime.parse(json['workOrder']) : null,
      inceptionReport: json['inceptionReport'] != null ? DateTime.parse(json['inceptionReport']) : null,
      survey: json['survey'] != null ? DateTime.parse(json['survey']) : null,
      alignmentLayout: json['alignmentLayout'] != null ? DateTime.parse(json['alignmentLayout']) : null,
      draftDPR: json['draftDPR'] != null ? DateTime.parse(json['draftDPR']) : null,
      drawings: json['drawings'] != null ? DateTime.parse(json['drawings']) : null,
      boq: json['boq'] != null ? DateTime.parse(json['boq']) : null,
      envClearance: json['envClearance'] != null ? DateTime.parse(json['envClearance']) : null,
      cashFlow: json['cashFlow'] != null ? DateTime.parse(json['cashFlow']) : null,
      laProposal: json['laProposal'] != null ? DateTime.parse(json['laProposal']) : null,
      utilityShifting: json['utilityShifting'] != null ? DateTime.parse(json['utilityShifting']) : null,
      finalDPR: json['finalDPR'] != null ? DateTime.parse(json['finalDPR']) : null,
      bidDocWork: json['bidDocWork'] != null ? DateTime.parse(json['bidDocWork']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'broadScope': broadScope,
      'bidDocDPR': bidDocDPR?.toIso8601String(),
      'tenderInvite': tenderInvite?.toIso8601String(),
      'prebid': prebid?.toIso8601String(),
      'csd': csd?.toIso8601String(),
      'bidSubmit': bidSubmit?.toIso8601String(),
      'workOrder': workOrder?.toIso8601String(),
      'inceptionReport': inceptionReport?.toIso8601String(),
      'survey': survey?.toIso8601String(),
      'alignmentLayout': alignmentLayout?.toIso8601String(),
      'draftDPR': draftDPR?.toIso8601String(),
      'drawings': drawings?.toIso8601String(),
      'boq': boq?.toIso8601String(),
      'envClearance': envClearance?.toIso8601String(),
      'cashFlow': cashFlow?.toIso8601String(),
      'laProposal': laProposal?.toIso8601String(),
      'utilityShifting': utilityShifting?.toIso8601String(),
      'finalDPR': finalDPR?.toIso8601String(),
      'bidDocWork': bidDocWork?.toIso8601String(),
    };
  }

  int getCompletionPercentage() {
    final fields = [
      bidDocDPR, tenderInvite, prebid, csd, bidSubmit, workOrder,
      inceptionReport, survey, alignmentLayout, draftDPR, drawings,
      boq, envClearance, cashFlow, laProposal, utilityShifting,
      finalDPR, bidDocWork
    ];
    final completed = fields.where((f) => f != null).length;
    return ((completed / fields.length) * 100).round();
  }
}
