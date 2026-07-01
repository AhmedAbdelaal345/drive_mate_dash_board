import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:drive_mate_dash_board/core/local/api_keys.dart';

class ApiResponse {
  ApiResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.data,
    this.accessToken,
    this.refreshToken,
  });

  final int statusCode;
  final dynamic data;
  final String? accessToken;
  final String? refreshToken;
  final String message;
  final bool status;

  // ── Safe Map extraction — never indexes a String/List ─────────────────
  static dynamic _safeGet(dynamic body, String key) {
    if (body is Map) return body[key];
    return null; // body is a String, List, null, etc. — nothing to extract
  }

  // Success response
  factory ApiResponse.fromResponse(Response response) {
    final body = response.data;

    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      status: _safeGet(body, ApiKeys.status) ?? false,
      message: _safeGet(body, ApiKeys.message)?.toString() ?? '',
      data: _safeGet(body, ApiKeys.data),
      accessToken: _safeGet(body, ApiKeys.accessToken)?.toString(),
      refreshToken: _safeGet(body, ApiKeys.refreshToken)?.toString(),
    );
  }

  // Error response
  factory ApiResponse.fromError(dynamic error) {
    if (error is DioException) {
      final res = error.response;

      return ApiResponse(
        statusCode: res?.statusCode ?? 500,
        status: false,
        message: _handleDioError(error),
        data: res?.data,
      );
    }

    return ApiResponse(
      statusCode: 500,
      status: false,
      message: error.toString(),
    );
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with server";
      case DioExceptionType.sendTimeout:
        return "Send timeout in connection with server";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with server";

      case DioExceptionType.badResponse:
        final responseData = error.response?.data;

        // ✅ Only index the body if it's actually a Map.
        // If the server returned plain text/HTML, fall back to that
        // text directly instead of crashing.
        final serverMessage = (responseData is Map)
            ? (responseData[ApiKeys.message]?.toString() ?? error.message)
            : (responseData?.toString() ?? error.message);

        log(
          "Invalid status code: ${error.response?.statusCode} , "
          "message: $serverMessage",
        );
        return "Invalid status code: ${error.response?.statusCode} , "
            "message: $serverMessage";

      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.connectionError:
        log("Connection Error: ${error.error}");
        log("Request URI: ${error.requestOptions.uri}");
        log("Message: ${error.message}");
        return "Internet connection error";
      case DioExceptionType.badCertificate:
        return "Bad certificate";
      case DioExceptionType.unknown:
        return "Unexpected error occurred";
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
