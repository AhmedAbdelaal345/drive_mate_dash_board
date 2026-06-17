import 'package:drive_mate_dash_board/features/reports/data/reports_repo.dart';
import 'package:drive_mate_dash_board/features/reports/manager/reports_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this.repo) : super(ReportsInitial());

  final ReportsRepo repo;

  Future<void> loadReports() async {
    emit(ReportsLoading());
    final response = await repo.getReports();
    if (response.success && response.data != null) {
      emit(ReportsSuccess(response.data!));
    } else {
      emit(ReportsError(response.message));
    }
  }
}
