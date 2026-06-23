import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      if (retryCount < maxRetries) {
        final delay = initialDelay * (1 << retryCount);
        await Future.delayed(delay);

        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          final dio = Dio();
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } on DioException catch (e) {
          handler.next(e);
          return;
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;
    final type = error.type;

    if (type == DioExceptionType.connectionError ||
        type == DioExceptionType.connectionTimeout) {
      return true;
    }

    if (statusCode != null && statusCode >= 500) {
      return true;
    }

    return false;
  }
}
