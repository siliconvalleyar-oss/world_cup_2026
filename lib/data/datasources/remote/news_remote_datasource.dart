import 'package:world_cup_2026/core/network/dio_client.dart';
import 'package:world_cup_2026/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews({Map<String, dynamic>? queryParameters});
  Future<NewsModel> getNewsById(String id);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final DioClient _dioClient;

  NewsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<NewsModel>> getNews({Map<String, dynamic>? queryParameters}) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/news',
      queryParameters: queryParameters,
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => NewsModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/news/$id',
    );
    return NewsModel.fromJson(response.data!);
  }
}
