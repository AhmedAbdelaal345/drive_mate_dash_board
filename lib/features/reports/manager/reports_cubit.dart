import 'package:drive_mate_dash_board/features/reports/data/reports_repo.dart';
import 'package:drive_mate_dash_board/features/reports/manager/reports_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this.repo) : super(ReportsInitial());

  final ReportsRepo repo;

  Future<void> loadReports() async {
    emit(ReportsLoading());
    await repo.getReports().then(
      (value) => value.fold(
        (l) => emit(ReportsError(l)),
        (r) => emit(ReportsSuccess(r)),
      ),
    );
  }
}
