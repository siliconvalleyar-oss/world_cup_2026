import 'package:dio/dio.dart';
import 'package:world_cup_2026/core/config/api_config.dart';
import 'package:world_cup_2026/core/network/api_response.dart';
import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/network/interceptors/auth_interceptor.dart';
import 'package:world_cup_2026/core/network/interceptors/logging_interceptor.dart';
import 'package:world_cup_2026/core/network/interceptors/retry_interceptor.dart';
import 'package:world_cup_2026/core/network/interceptors/cache_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      AppLoggingInterceptor(),
      RetryInterceptor(),
      CacheInterceptor(),
    ]);
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiResponse<T> _parseResponse<T>(Response<dynamic> response) {
    return ApiResponse<T>(
      data: response.data as T,
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? 'Success',
    );
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: error.message ?? 'Request timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: error.message ?? 'Network error',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data?['message'] ?? error.message;
        if (statusCode >= 500) {
          return ServerException(
            message: message ?? 'Server error',
            statusCode: statusCode,
          );
        }
        return ApiException(
          message: message ?? 'API error',
          statusCode: statusCode,
        );
      default:
        return AppException(
          message: error.message ?? 'Unknown error',
        );
    }
  }
}