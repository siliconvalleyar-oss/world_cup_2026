import 'package:dio/dio.dart';
import 'package:world_cup_2026/core/config/api_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'Authorization': 'Bearer ${ApiConfig.apiKey}',
    });
    handler.next(options);
  }
}
