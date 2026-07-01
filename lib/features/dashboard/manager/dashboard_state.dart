import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_metric_model.dart';

sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  DashboardSuccess(this.metrics, this.activities);

  final List<DashboardMetricModel> metrics;
  final List<ActivityItemModel> activities;
}

class DashboardError extends DashboardState {
  DashboardError(this.message);

  final String message;
}
