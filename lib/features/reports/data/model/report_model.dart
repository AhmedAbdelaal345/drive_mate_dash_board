class ReportModel {
  const ReportModel({
    required this.id,
    required this.user,
    required this.type,
    required this.date,
    required this.status,
    required this.priority,
    required this.title,
  });

  final String id;
  final String user;
  final String type;
  final String date;
  final String status;
  final String priority;
  final String title;
}
