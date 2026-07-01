import 'package:drive_mate_dash_board/features/admins/data/model/admin_model.dart';

sealed class AdminsState {
  const AdminsState();
}

class AdminsInitial extends AdminsState {
  const AdminsInitial();
}

class AdminsLoading extends AdminsState {
  const AdminsLoading();
}

class AdminsSuccess extends AdminsState {
  const AdminsSuccess(this.admins);

  final List<AdminModel> admins;
}

class AdminsError extends AdminsState {
  const AdminsError(this.message);

  final String message;
}
