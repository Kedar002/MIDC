class WorkData {
  DateTime? aa;
  DateTime? dpr;
  DateTime? ts;
  DateTime? bidDoc;
  DateTime? bidInvite;
  DateTime? prebid;
  DateTime? csd;
  DateTime? bidSubmit;
  DateTime? finBid;
  DateTime? loi;
  DateTime? loa;
  DateTime? pbg;
  DateTime? agreement;
  DateTime? workOrder;

  WorkData({
    this.aa,
    this.dpr,
    this.ts,
    this.bidDoc,
    this.bidInvite,
    this.prebid,
    this.csd,
    this.bidSubmit,
    this.finBid,
    this.loi,
    this.loa,
    this.pbg,
    this.agreement,
    this.workOrder,
  });

  factory WorkData.fromJson(Map<String, dynamic> json) {
    return WorkData(
      aa: json['aa'] != null ? DateTime.parse(json['aa']) : null,
      dpr: json['dpr'] != null ? DateTime.parse(json['dpr']) : null,
      ts: json['ts'] != null ? DateTime.parse(json['ts']) : null,
      bidDoc: json['bidDoc'] != null ? DateTime.parse(json['bidDoc']) : null,
      bidInvite: json['bidInvite'] != null ? DateTime.parse(json['bidInvite']) : null,
      prebid: json['prebid'] != null ? DateTime.parse(json['prebid']) : null,
      csd: json['csd'] != null ? DateTime.parse(json['csd']) : null,
      bidSubmit: json['bidSubmit'] != null ? DateTime.parse(json['bidSubmit']) : null,
      finBid: json['finBid'] != null ? DateTime.parse(json['finBid']) : null,
      loi: json['loi'] != null ? DateTime.parse(json['loi']) : null,
      loa: json['loa'] != null ? DateTime.parse(json['loa']) : null,
      pbg: json['pbg'] != null ? DateTime.parse(json['pbg']) : null,
      agreement: json['agreement'] != null ? DateTime.parse(json['agreement']) : null,
      workOrder: json['workOrder'] != null ? DateTime.parse(json['workOrder']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aa': aa?.toIso8601String(),
      'dpr': dpr?.toIso8601String(),
      'ts': ts?.toIso8601String(),
      'bidDoc': bidDoc?.toIso8601String(),
      'bidInvite': bidInvite?.toIso8601String(),
      'prebid': prebid?.toIso8601String(),
      'csd': csd?.toIso8601String(),
      'bidSubmit': bidSubmit?.toIso8601String(),
      'finBid': finBid?.toIso8601String(),
      'loi': loi?.toIso8601String(),
      'loa': loa?.toIso8601String(),
      'pbg': pbg?.toIso8601String(),
      'agreement': agreement?.toIso8601String(),
      'workOrder': workOrder?.toIso8601String(),
    };
  }

  int getCompletionPercentage() {
    final fields = [
      aa, dpr, ts, bidDoc, bidInvite, prebid, csd,
      bidSubmit, finBid, loi, loa, pbg, agreement, workOrder
    ];
    final completed = fields.where((f) => f != null).length;
    return ((completed / fields.length) * 100).round();
  }
}
