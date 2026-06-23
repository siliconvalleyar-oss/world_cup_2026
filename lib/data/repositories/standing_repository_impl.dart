import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/datasources/local/standing_local_datasource.dart';
import 'package:world_cup_2026/data/datasources/remote/standing_remote_datasource.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/domain/repositories/standing_repository.dart';

class StandingRepositoryImpl implements StandingRepository {
  final StandingRemoteDataSource _remoteDataSource;
  final StandingLocalDataSource _localDataSource;

  StandingRepositoryImpl({
    required StandingRemoteDataSource remoteDataSource,
    required StandingLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<GroupModel>>> getGroups() async {
    try {
      final groups = await _remoteDataSource.getGroups();
      await _localDataSource.cacheGroups(groups);
      return Right(groups);
    } on AppException catch (e) {
      try {
        final cachedGroups = await _localDataSource.getCachedGroups();
        if (cachedGroups.isNotEmpty) {
          return Right(cachedGroups);
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StandingModel>>> getStandings() async {
    try {
      final standings = await _remoteDataSource.getStandings();
      await _localDataSource.cacheStandings(standings);
      return Right(standings);
    } on AppException catch (e) {
      try {
        final cachedStandings = await _localDataSource.getCachedStandings();
        if (cachedStandings.isNotEmpty) {
          return Right(cachedStandings);
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
