class MonitoringData {
  double? agreementAmount;
  DateTime? appointedDate;
  String? tenderPeriod;
  int? firstMilestone;
  int? secondMilestone;
  int? thirdMilestone;
  int? fourthMilestone;
  int? fifthMilestone;
  String? ld;
  String? cos;
  String? eot;
  double? cumulativeExpenditure;
  double? finalBill;
  String? auditPara;
  String? replies;
  String? laqLcq;
  String? techAudit;

  MonitoringData({
    this.agreementAmount,
    this.appointedDate,
    this.tenderPeriod,
    this.firstMilestone,
    this.secondMilestone,
    this.thirdMilestone,
    this.fourthMilestone,
    this.fifthMilestone,
    this.ld,
    this.cos,
    this.eot,
    this.cumulativeExpenditure,
    this.finalBill,
    this.auditPara,
    this.replies,
    this.laqLcq,
    this.techAudit,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    return MonitoringData(
      agreementAmount: json['agreementAmount']?.toDouble(),
      appointedDate: json['appointedDate'] != null ? DateTime.parse(json['appointedDate']) : null,
      tenderPeriod: json['tenderPeriod'],
      firstMilestone: json['firstMilestone'],
      secondMilestone: json['secondMilestone'],
      thirdMilestone: json['thirdMilestone'],
      fourthMilestone: json['fourthMilestone'],
      fifthMilestone: json['fifthMilestone'],
      ld: json['ld'],
      cos: json['cos'],
      eot: json['eot'],
      cumulativeExpenditure: json['cumulativeExpenditure']?.toDouble(),
      finalBill: json['finalBill']?.toDouble(),
      auditPara: json['auditPara'],
      replies: json['replies'],
      laqLcq: json['laqLcq'],
      techAudit: json['techAudit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agreementAmount': agreementAmount,
      'appointedDate': appointedDate?.toIso8601String(),
      'tenderPeriod': tenderPeriod,
      'firstMilestone': firstMilestone,
      'secondMilestone': secondMilestone,
      'thirdMilestone': thirdMilestone,
      'fourthMilestone': fourthMilestone,
      'fifthMilestone': fifthMilestone,
      'ld': ld,
      'cos': cos,
      'eot': eot,
      'cumulativeExpenditure': cumulativeExpenditure,
      'finalBill': finalBill,
      'auditPara': auditPara,
      'replies': replies,
      'laqLcq': laqLcq,
      'techAudit': techAudit,
    };
  }

  int getOverallMilestoneProgress() {
    final milestones = [
      firstMilestone ?? 0,
      secondMilestone ?? 0,
      thirdMilestone ?? 0,
      fourthMilestone ?? 0,
      fifthMilestone ?? 0,
    ];
    final total = milestones.reduce((a, b) => a + b);
    return (total / 5).round();
  }
}
