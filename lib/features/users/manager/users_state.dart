import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';

sealed class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  UsersSuccess(this.users);

  final List<UserModel> users;
}

class UsersError extends UsersState {
  UsersError(this.message);

  final String message;
}
