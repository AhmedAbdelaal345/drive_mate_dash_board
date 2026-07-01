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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String? ?? '',
      user: json['user'] as String? ?? '',
      type: json['type'] as String? ?? '',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }
}
