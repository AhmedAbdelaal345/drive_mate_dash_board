import 'package:drive_mate_dash_board/features/dashboard/data/dashboard_repo.dart';
import 'package:drive_mate_dash_board/features/dashboard/manager/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.repo) : super(DashboardInitial());

  final DashboardRepo repo;

  Future<void> load() async {
    emit(DashboardLoading());
    final response = await repo.getDashboardData();
    if (response.success && response.data != null) {
      emit(DashboardSuccess(response.data!));
    } else {
      emit(DashboardError(response.message));
    }
  }
}
