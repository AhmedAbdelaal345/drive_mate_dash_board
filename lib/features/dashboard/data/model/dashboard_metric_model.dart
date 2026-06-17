class DashboardMetricModel {
  const DashboardMetricModel({
    required this.title,
    required this.value,
    required this.delta,
    required this.iconName,
  });

  final String title;
  final String value;
  final String delta;
  final String iconName;
}
