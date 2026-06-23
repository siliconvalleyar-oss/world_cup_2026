import 'dart:convert';

import 'package:world_cup_2026/core/services/hive_service.dart';
import 'package:world_cup_2026/data/models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getCachedNews();
  Future<void> cacheNews(List<NewsModel> news);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final HiveService _hiveService;

  static const String _newsKey = 'cached_news';

  NewsLocalDataSourceImpl(this._hiveService);

  @override
  Future<List<NewsModel>> getCachedNews() async {
    final data = await _hiveService.get<String>(_newsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((json) => NewsModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheNews(List<NewsModel> news) async {
    final jsonList = news.map((n) => n.toJson()).toList();
    await _hiveService.set<String>(
      _newsKey,
      jsonEncode(jsonList),
      expiration: const Duration(minutes: 15),
    );
  }
}
