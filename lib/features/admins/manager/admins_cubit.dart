import 'package:drive_mate_dash_board/features/admins/data/admins_repo.dart';
import 'package:drive_mate_dash_board/features/admins/manager/admins_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminsCubit extends Cubit<AdminsState> {
  AdminsCubit(this.repo) : super(AdminsInitial());

  final AdminsRepo repo;

  Future<void> loadAdmins() async {
    emit(AdminsLoading());
    final response = await repo.getAdmins();
    if (response.success && response.data != null) {
      emit(AdminsSuccess(response.data!));
    } else {
      emit(AdminsError(response.message));
    }
  }
}
