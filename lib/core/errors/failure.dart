abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    return 'Failure: $message (statusCode: $statusCode)';
  }
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}
