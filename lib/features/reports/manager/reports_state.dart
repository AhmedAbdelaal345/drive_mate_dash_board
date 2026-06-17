import 'package:drive_mate_dash_board/features/reports/data/model/report_model.dart';

sealed class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsSuccess extends ReportsState {
  ReportsSuccess(this.reports);

  final List<ReportModel> reports;
}

class ReportsError extends ReportsState {
  ReportsError(this.message);

  final String message;
}
