import 'package:drive_mate_dash_board/features/users/data/users_repo.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this.repo) : super(UsersInitial());

  final UsersRepo repo;

  Future<void> loadUsers() async {
    emit(UsersLoading());
    final response = await repo.getUsers();
    if (response.success && response.data != null) {
      emit(UsersSuccess(response.data!));
    } else {
      emit(UsersError(response.message));
    }
  }
}
