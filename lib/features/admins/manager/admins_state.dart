import 'package:drive_mate_dash_board/features/admins/data/model/admin_model.dart';

sealed class AdminsState {}

class AdminsInitial extends AdminsState {}

class AdminsLoading extends AdminsState {}

class AdminsSuccess extends AdminsState {
  AdminsSuccess(this.admins);

  final List<AdminModel> admins;
}

class AdminsError extends AdminsState {
  AdminsError(this.message);

  final String message;
}
