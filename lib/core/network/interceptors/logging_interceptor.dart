import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AppLoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    _logger.d('Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      _logger.d('QueryParameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      _logger.d('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    _logger.i('Response Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    _logger.e('Error Message: ${err.message}');
    if (err.response?.data != null) {
      _logger.e('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}
