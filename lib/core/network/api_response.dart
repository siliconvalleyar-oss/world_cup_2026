class ApiResponse<T> {
  final T? data;
  final String message;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.message = '',
    this.statusCode = 0,
    this.isSuccess = true,
  });

  factory ApiResponse.success(T data, {String message = 'Success', int statusCode = 200}) {
    return ApiResponse<T>(
      data: data,
      message: message,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  factory ApiResponse.error({required String message, int statusCode = 0}) {
    return ApiResponse<T>(
      data: null,
      message: message,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  ApiResponse<T> copyWith({
    T? data,
    String? message,
    int? statusCode,
    bool? isSuccess,
  }) {
    return ApiResponse<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(data: $data, message: $message, statusCode: $statusCode, isSuccess: $isSuccess)';
  }
}
