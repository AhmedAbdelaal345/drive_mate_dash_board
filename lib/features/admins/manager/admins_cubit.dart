import 'package:drive_mate_dash_board/features/admins/data/admins_repo.dart';
import 'package:drive_mate_dash_board/features/admins/manager/admins_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminsCubit extends Cubit<AdminsState> {
  AdminsCubit(this._repo) : super(const AdminsInitial());

  final AdminsRepo _repo;

  Future<void> loadAdmins() async {
    emit(const AdminsLoading());
    try {
      final response = await _repo.fetchAdmins();
      response.fold((l) => emit(AdminsError(l)), (r) => emit(AdminsSuccess(r)));
    } catch (e) {
      emit(AdminsError(e.toString()));
    }
  }
}
