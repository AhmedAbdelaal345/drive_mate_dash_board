import 'package:drive_mate_dash_board/features/dashboard/data/dashboard_repo.dart';
import 'package:drive_mate_dash_board/features/dashboard/manager/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.repo) : super(DashboardInitial());

  final DashboardRepo repo;

  Future<void> load() async {
    emit(DashboardLoading());
    try {
      final response = await repo.getDashboardData();
      emit(DashboardSuccess(response.metrics, response.activities));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data'));
    }
  }
}
