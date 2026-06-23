import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheInterceptor extends Interceptor {
  static const String _cacheBoxName = 'api_cache';

  Future<Box<String>> get _cacheBox async {
    return Hive.openBox<String>(_cacheBoxName);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method == 'GET') {
      final cacheKey = _generateCacheKey(options);
      final box = await _cacheBox;

      if (box.containsKey(cacheKey)) {
        final cachedData = box.get(cacheKey)!;
        final cacheEntry = jsonDecode(cachedData) as Map<String, dynamic>;
        final expiry = DateTime.parse(cacheEntry['expiry'] as String);

        if (DateTime.now().isBefore(expiry)) {
          final responseData = cacheEntry['data'];
          handler.resolve(
            Response(
              requestOptions: options,
              data: responseData,
              statusCode: 200,
              extra: {'fromCache': true},
            ),
          );
          return;
        } else {
          await box.delete(cacheKey);
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method == 'GET' &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      final box = await _cacheBox;
      final cacheControl = response.headers.value('cache-control');

      if (cacheControl != null && !cacheControl.contains('no-store')) {
        final maxAge = _parseMaxAge(cacheControl);
        final expiry = DateTime.now().add(Duration(seconds: maxAge));

        final cacheEntry = {
          'data': response.data,
          'expiry': expiry.toIso8601String(),
        };

        await box.put(cacheKey, jsonEncode(cacheEntry));
      }
    }
    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final method = options.method;
    return '$method:$uri';
  }

  int _parseMaxAge(String cacheControl) {
    final parts = cacheControl.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.startsWith('max-age=')) {
        return int.tryParse(trimmed.substring(8)) ?? 300;
      }
    }
    return 300;
  }

  Future<void> clearCache() async {
    final box = await _cacheBox;
    await box.clear();
  }

  Future<void> removeCachedResponse(String url) async {
    final box = await _cacheBox;
    final keysToRemove = box.keys.where((key) =>
        key.toString().contains(url)).toList();
    for (final key in keysToRemove) {
      await box.delete(key);
    }
  }
}
