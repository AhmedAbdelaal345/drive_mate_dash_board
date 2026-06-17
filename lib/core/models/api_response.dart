class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final T? data;

  factory ApiResponse.success(T data, {String message = 'Success'}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.failure(String message) {
    return ApiResponse(success: false, message: message);
  }
}
