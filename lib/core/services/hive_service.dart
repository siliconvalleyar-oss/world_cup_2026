import 'package:hive_flutter/hive_flutter.dart';
import 'package:world_cup_2026/core/errors/app_exception.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  late Box<dynamic> _box;

  factory HiveService() => _instance;

  HiveService._internal();

  Future<void> init({String boxName = 'world_cup_cache'}) async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
  }

  Future<T?> get<T>(String key) async {
    try {
      final data = _box.get(key);
      if (data == null) return null;

      if (data is Map && data.containsKey('expiry')) {
        final expiry = DateTime.parse(data['expiry'] as String);
        if (DateTime.now().isAfter(expiry)) {
          await _box.delete(key);
          return null;
        }
        return data['data'] as T;
      }

      return data as T;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached data: $e');
    }
  }

  Future<void> set<T>(
    String key,
    T value, {
    Duration? expiration,
  }) async {
    try {
      if (expiration != null) {
        final expiry = DateTime.now().add(expiration);
        await _box.put(key, {
          'data': value,
          'expiry': expiry.toIso8601String(),
        });
      } else {
        await _box.put(key, value);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache data: $e');
    }
  }

  Future<void> delete(String key) async {
    try {
      await _box.delete(key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete cached data: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> removeExpiredEntries() async {
    try {
      final keysToDelete = <dynamic>[];
      for (final key in _box.keys) {
        final data = _box.get(key);
        if (data is Map && data.containsKey('expiry')) {
          final expiry = DateTime.parse(data['expiry'] as String);
          if (DateTime.now().isAfter(expiry)) {
            keysToDelete.add(key);
          }
        }
      }
      await _box.deleteAll(keysToDelete);
    } catch (e) {
      throw CacheException(message: 'Failed to remove expired entries: $e');
    }
  }

  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  int get length => _box.length;

  List<String> get keys => _box.keys.cast<String>().toList();
}
