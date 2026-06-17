import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/core/constants/app_constants.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';

class AuthRepo {
  // TODO: Connect to Backend
  AuthRepo._singeleTone();
  static final AuthRepo instant = AuthRepo._singeleTone();

  factory AuthRepo() {
    return instant;
  }

  Either<String, AdminType> login({
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail == AppConstants.superEmail &&
        password == AppConstants.password) {
      return const Right(AdminType.superAdmin);
    } else if (cleanEmail == AppConstants.communityEmail &&
        password == AppConstants.password) {
      return const Right(AdminType.communityAdmin);
    } else if (cleanEmail == AppConstants.opsEmail &&
        password == AppConstants.password) {
      return const Right(AdminType.opsAdmin);
    } else {
      return const Left(AppConstants.accessDenied);
    }
  }
}
