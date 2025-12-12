class AppConstants {
  // App Info
  static const String appName = 'MSIDC PMS';
  static const String appFullName = 'MSIDC Project Management System';

  // Project Categories
  static const Map<String, String> categories = {
    'A': 'Nashik Kumbhmela',
    'B': 'HAM Projects',
    'C': 'Nagpur Works',
    'D': 'NHAI Projects',
    'E': 'Other Projects',
  };

  // DPR Field Labels
  static const List<Map<String, String>> dprFields = [
    {'label': 'Broad Scope', 'responsiblePerson': 'Engineering'},
    {'label': 'Bid Doc DPR', 'responsiblePerson': 'Engineering'},
    {'label': 'Tender Invite', 'responsiblePerson': 'Tender'},
    {'label': 'Prebid', 'responsiblePerson': 'Tender'},
    {'label': 'CSD', 'responsiblePerson': 'CE'},
    {'label': 'Bid Submit', 'responsiblePerson': 'Tender'},
    {'label': 'Work Order', 'responsiblePerson': 'Tender'},
    {'label': 'Inception Report', 'responsiblePerson': 'EE Concerned'},
    {'label': 'Survey', 'responsiblePerson': 'EE'},
    {'label': 'Alignment / Layout', 'responsiblePerson': 'SE/CE'},
    {'label': 'Draft DPR', 'responsiblePerson': 'CE'},
    {'label': 'Drawings', 'responsiblePerson': 'EE/SE/CE'},
    {'label': 'BOQ', 'responsiblePerson': 'EE'},
    {'label': 'Env Clearance', 'responsiblePerson': 'SE'},
    {'label': 'Cash-Flow', 'responsiblePerson': 'Fin Adv'},
    {'label': 'LA Proposal', 'responsiblePerson': 'EE'},
    {'label': 'Utility Shifting', 'responsiblePerson': 'SE'},
    {'label': 'Final DPR', 'responsiblePerson': 'JMD/MD'},
    {'label': 'Bid Doc Work', 'responsiblePerson': 'CE'},
  ];

  // Work Field Labels
  static const List<Map<String, String>> workFields = [
    {'label': 'AA', 'fullName': 'Administrative Approval', 'responsiblePerson': 'JMD/MD'},
    {'label': 'DPR', 'fullName': 'Detailed Project Report', 'responsiblePerson': 'JMD'},
    {'label': 'TS', 'fullName': 'Technical Sanction', 'responsiblePerson': 'JMD/CE'},
    {'label': 'Bid Doc', 'fullName': 'Bid Document', 'responsiblePerson': 'CE'},
    {'label': 'Bid Invite', 'fullName': 'Bid Invitation', 'responsiblePerson': 'Tender'},
    {'label': 'Prebid', 'fullName': 'Pre-bid Meeting', 'responsiblePerson': 'Tender/SE'},
    {'label': 'CSD', 'fullName': 'CSD', 'responsiblePerson': 'CE'},
    {'label': 'Bid Submit', 'fullName': 'Bid Submission', 'responsiblePerson': 'Tender'},
    {'label': 'Fin Bid', 'fullName': 'Financial Bid', 'responsiblePerson': 'SE'},
    {'label': 'LOI', 'fullName': 'Letter of Intent', 'responsiblePerson': 'Tender'},
    {'label': 'LOA', 'fullName': 'Letter of Acceptance', 'responsiblePerson': 'SE'},
    {'label': 'PBG', 'fullName': 'Performance Bank Guarantee', 'responsiblePerson': 'Tender'},
    {'label': 'Agreement', 'fullName': 'Agreement', 'responsiblePerson': 'CE'},
    {'label': 'Work Order', 'fullName': 'Work Order', 'responsiblePerson': 'EE'},
  ];

  // Monitoring Field Labels
  static const List<Map<String, String>> monitoringFields = [
    {'label': 'Agmnt Amount', 'fullName': 'Agreement Amount (Rs. Crore)', 'responsiblePerson': 'EE', 'type': 'number'},
    {'label': 'Appointed Date', 'fullName': 'Appointed Date', 'responsiblePerson': 'SE', 'type': 'date'},
    {'label': 'Tender Period', 'fullName': 'Tender Period', 'responsiblePerson': 'EE', 'type': 'text'},
    {'label': 'First Milestone', 'fullName': 'First Milestone', 'responsiblePerson': 'EE', 'type': 'percentage'},
    {'label': 'Second Milestone', 'fullName': 'Second Milestone', 'responsiblePerson': 'EE', 'type': 'percentage'},
    {'label': 'Third Milestone', 'fullName': 'Third Milestone', 'responsiblePerson': 'EE', 'type': 'percentage'},
    {'label': 'Fourth Milestone', 'fullName': 'Fourth Milestone', 'responsiblePerson': 'EE', 'type': 'percentage'},
    {'label': 'Fifth Milestone', 'fullName': 'Fifth Milestone', 'responsiblePerson': 'SE', 'type': 'percentage'},
    {'label': 'LD', 'fullName': 'Liquidated Damages', 'responsiblePerson': 'EE', 'type': 'text'},
    {'label': 'COS', 'fullName': 'Change of Scope', 'responsiblePerson': 'CE', 'type': 'text'},
    {'label': 'EOT', 'fullName': 'Extension of Time', 'responsiblePerson': 'JMD', 'type': 'text'},
    {'label': 'Cum Exp', 'fullName': 'Cumulative Expenditure', 'responsiblePerson': 'Fin', 'type': 'number'},
    {'label': 'Final Bill', 'fullName': 'Final Bill', 'responsiblePerson': 'JMD', 'type': 'number'},
    {'label': 'Audit Para', 'fullName': 'Audit Para', 'responsiblePerson': 'Fin', 'type': 'text'},
    {'label': 'Replies', 'fullName': 'Replies', 'responsiblePerson': 'SE', 'type': 'text'},
    {'label': 'LAQ/ LCQ', 'fullName': 'LAQ/ LCQ', 'responsiblePerson': 'SE', 'type': 'text'},
    {'label': 'Tech Audit', 'fullName': 'Technical Audit', 'responsiblePerson': 'JMD', 'type': 'text'},
  ];

  // Work Entry Activities
  static const List<String> workEntryActivities = [
    'AA',
    'Broad Scope',
    'DPR Bid Doc',
    'Inviting DPR Bid',
    'CSD',
    'Bid Submission',
    'Bid Opening',
    'Technical Evaluation',
    'Financial Opening',
    'LOA',
    'PBG submission',
    'Insurance Submission',
    'Work Order',
    'Inception Report',
    'Survey',
    'Geotechnical Investigation',
    'Fixing of alignment',
    'Plan & Profile',
    'Pavement Design',
    'Structures Design',
    'Traffic Survey',
    'BOQ',
    'Draft DPR',
    'Environmental Clearance',
    'Land Acquisition',
    'Utility Shifting',
    'Quarry Chart',
    'Final DPR',
    'DPR Approval',
    'Contractor Bid Doc',
    'RFP',
    'GCC',
    'Schedules',
    'Drawings Volume',
  ];

  // Responsible Persons
  static const List<String> responsiblePersons = [
    'Engineering',
    'CE',
    'EE',
    'SE',
    'Tender',
    'JMD',
    'MD',
    'JMD/MD',
    'JMD/CE',
    'Tender/SE',
    'EE/SE/CE',
    'EE Concerned',
    'SE/CE',
    'Fin Adv',
    'Fin',
  ];

  // Post Held Options
  static const List<String> postHeld = [
    'Chief Engineer',
    'Executive Engineer',
    'Superintending Engineer',
    'Junior Engineer',
    'Assistant Engineer',
    'Joint Managing Director',
    'Managing Director',
    'Finance Advisor',
    'Tender Department',
  ];

  // Project Status
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusCompleted = 'Completed';

  static const List<String> projectStatuses = [
    'All',
    statusPending,
    statusInProgress,
    statusCompleted,
  ];
}
