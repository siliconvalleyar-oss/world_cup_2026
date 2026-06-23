import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/models/news_model.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsModel>>> getNews({Map<String, dynamic>? queryParameters});
  Future<Either<Failure, NewsModel>> getNewsById(String id);
}
