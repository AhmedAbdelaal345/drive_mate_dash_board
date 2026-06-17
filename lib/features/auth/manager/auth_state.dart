import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateSuccessfully extends AuthState {
  AuthStateSuccessfully({required this.type, required this.email});

  final AdminType type;
  final String email;
}

class AuthStateLoading extends AuthState {}

class AuthStateError extends AuthState {
  AuthStateError({required this.error});

  final String error;
}
