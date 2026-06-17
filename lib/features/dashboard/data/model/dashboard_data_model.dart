import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_metric_model.dart';

class DashboardDataModel {
  const DashboardDataModel({required this.metrics, required this.activities});

  final List<DashboardMetricModel> metrics;
  final List<ActivityItemModel> activities;
}
