import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drive_mate_dash_board/core/constants/app_constants.dart';
import 'package:drive_mate_dash_board/core/network/api_constants.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class AuthRepo {
  AuthRepo._singeleTone();
  static final AuthRepo instant = AuthRepo._singeleTone();

  factory AuthRepo() {
    return instant;
  }

  Future<Either<String, AdminType>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiHelper().postRequest(
        endpoint: 'auth/login',
        isAuthorized: false,
        isForm: false,
        data: AuthModel(
          email: email.trim(),
          password: password.trim(),
        ).toJson(),
      );
      debugPrint("Success: ${response.status}");
      debugPrint("Message: ${response.message}");
      debugPrint("Data: ${response.data}");
      debugPrint("Type: ${response.data.runtimeType}");

      final loginData = AuthLoginData.fromJson(response.data!);

      final adminType = AdminTypeX.fromApiRole(loginData.role);

      if (adminType == null) {
        return const Left(AppConstants.accessDenied);
      }

      // ✅ Save tokens so all subsequent API calls are authenticated
      ApiConstants.accessToken = loginData.accessToken;
      ApiConstants.refreshToken = loginData.refreshToken;

      return Right(adminType);
    } on DioException catch (e) {
      // This gives you the REAL reason
      debugPrint("=== DIO ERROR ===");

      debugPrint("Dio Error Type: ${e.type}");
      debugPrint("Dio Error Message: ${e.message}");
      debugPrint("Dio Response: ${e.response?.statusCode}");
      debugPrint("Dio Response Data: ${e.response?.data}");

      return Left(e.message ?? "Connection failed");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
