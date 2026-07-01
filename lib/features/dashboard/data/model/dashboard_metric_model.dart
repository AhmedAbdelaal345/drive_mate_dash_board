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

class DashboardStatsModel {
  const DashboardStatsModel({
    required this.activeUsers,
    required this.totalCars,
    required this.revenue,
    required this.pendingReviews,
  });

  final int activeUsers;
  final int totalCars;
  final num revenue;
  final int pendingReviews;

  List<DashboardMetricModel> toMetrics() {
    return [
      DashboardMetricModel(
        title: 'Active Users',
        value: '$activeUsers',
        delta: '',
        iconName: 'users',
      ),
      DashboardMetricModel(
        title: 'Total Cars',
        value: '$totalCars',
        delta: '',
        iconName: 'pulse',
      ),
      DashboardMetricModel(
        title: 'Revenue',
        value: '\$${revenue.toStringAsFixed(2)}',
        delta: '',
        iconName: 'trend',
      ),
      DashboardMetricModel(
        title: 'Pending Reviews',
        value: '$pendingReviews',
        delta: '',
        iconName: 'grid',
      ),
    ];
  }

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      activeUsers: json['activeUsers'] as int? ?? 0,
      totalCars: json['totalCars'] as int? ?? 0,
      revenue: json['revenue'] as num? ?? 0,
      pendingReviews: json['pendingReviews'] as int? ?? 0,
    );
  }
}
