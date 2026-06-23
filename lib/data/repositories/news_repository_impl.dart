import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/datasources/local/news_local_datasource.dart';
import 'package:world_cup_2026/data/datasources/remote/news_remote_datasource.dart';
import 'package:world_cup_2026/data/models/news_model.dart';
import 'package:world_cup_2026/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;

  NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NewsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<NewsModel>>> getNews({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final news = await _remoteDataSource.getNews(
        queryParameters: queryParameters,
      );
      await _localDataSource.cacheNews(news);
      return Right(news);
    } on AppException catch (e) {
      try {
        final cachedNews = await _localDataSource.getCachedNews();
        if (cachedNews.isNotEmpty) {
          return Right(cachedNews);
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NewsModel>> getNewsById(String id) async {
    try {
      final news = await _remoteDataSource.getNewsById(id);
      return Right(news);
    } on AppException catch (e) {
      try {
        final cachedNews = await _localDataSource.getCachedNews();
        final found = cachedNews.where((n) => n.id == id);
        if (found.isNotEmpty) {
          return Right(found.first);
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _toFailure(AppException e) {
    if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is TimeoutException) {
      return TimeoutFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is CacheException) {
      return CacheFailure(message: e.message, statusCode: e.statusCode);
    }
    return ServerFailure(message: e.message, statusCode: e.statusCode);
  }
}
