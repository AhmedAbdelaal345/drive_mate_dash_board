import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_data_model.dart';

sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  DashboardSuccess(this.data);

  final DashboardDataModel data;
}

class DashboardError extends DashboardState {
  DashboardError(this.message);

  final String message;
}
