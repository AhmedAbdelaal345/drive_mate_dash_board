import 'package:dio/dio.dart';
import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/core/network/api_constants.dart';

class ApiHelper {
  ApiHelper._internal();
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static final ApiHelper instance = ApiHelper._internal();
  factory ApiHelper() {
    return instance;
  }

  Future<ApiResponse> postRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isAuthorized = true,
    bool isForm = true,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final body = isForm ? FormData.fromMap(data ?? {}) : data;

      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {
            if (isAuthorized)
              ApiConstants.authorization: "Bearer ${ApiConstants.accessToken}",

            "Accept": "application/json",

            if (!isForm) "Content-Type": "application/json",

            if (headers != null) ...headers,
          },
        ),
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<Response> rawPostRequest({
    required String fullUrl,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.post(
      fullUrl,
      data: data,
      options: Options(
        headers: headers,
        responseType: ResponseType.plain,

        /// مهم جدًا
        contentType: Headers.formUrlEncodedContentType,

        /// عشان مايرميش exception
        validateStatus: (status) => true,
      ),
    );
  }

  Future<ApiResponse> getRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isForm = true, // ✅ changed default — GET should not send form data
    bool isAuthorized = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.get(
        endpoint,
        // ✅ Only attach a body if the caller explicitly passed `data`.
        // GET requests with an empty FormData body get rejected by many
        // servers (including ASP.NET Core) with a non-JSON 400 response.
        data: data == null ? null : (isForm ? FormData.fromMap(data) : data),
        options: Options(
          headers: {
            if (isAuthorized)
              ApiConstants.authorization: "Bearer ${ApiConstants.accessToken}",
          },
        ),
        queryParameters: queryParameters,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> putRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isForm = true,
    bool isAuthorized = true,
  }) async {
    try {
      Response response = await dio.put(
        endpoint,
        data: isForm ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {
            if (isAuthorized)
              ApiConstants.authorization: "Bearer ${ApiConstants.accessToken}",
          },
        ),
      );
      return ApiResponse.fromResponse(response);
    } on Exception catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> deleteRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isForm = true,
    bool isAuthorized = true,
  }) async {
    try {
      Response response = await dio.delete(
        endpoint,
        data: isForm ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {
            if (isAuthorized)
              ApiConstants.authorization: "Bearer ${ApiConstants.accessToken}",
          },
        ),
      );
      return ApiResponse.fromResponse(response);
    } on Exception catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}
