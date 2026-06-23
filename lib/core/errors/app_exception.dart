class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    return 'AppException: $message (statusCode: $statusCode)';
  }
}

class ApiException extends AppException {
  ApiException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class CacheException extends AppException {
  CacheException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkException extends AppException {
  NetworkException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class TimeoutException extends AppException {
  TimeoutException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class ServerException extends AppException {
  ServerException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}
