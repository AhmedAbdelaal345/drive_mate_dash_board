import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/auth/data/repo/auth_repo.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_state.dart';
import 'package:flutter/material.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateInitial());

  final AuthRepo repo = AuthRepo();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    emit(AuthStateLoading());
    try {
      final Either<String, AdminType> result = await repo.login(
        email: emailController.text,
        password: passwordController.text,
      );
      result.fold(
        (l) {
          emit(AuthStateError(error: l));
        },
        (r) {
          emit(AuthStateSuccessfully(type: r, email: emailController.text));
        },
      );
    } catch (e) {
      emit(AuthStateError(error: 'Error occurred in Login: ${e.toString()}'));
    }
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    emit(AuthStateInitial());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
