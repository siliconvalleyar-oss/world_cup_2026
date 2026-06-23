import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/datasources/local/team_local_datasource.dart';
import 'package:world_cup_2026/data/datasources/remote/team_remote_datasource.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/domain/entities/team_entity.dart';
import 'package:world_cup_2026/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource _remoteDataSource;
  final TeamLocalDataSource _localDataSource;

  TeamRepositoryImpl({
    required TeamRemoteDataSource remoteDataSource,
    required TeamLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<TeamEntity>>> getTeams({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final teams = await _remoteDataSource.getTeams(
        queryParameters: queryParameters,
      );
      await _localDataSource.cacheTeams(teams);
      return Right(teams.map(_toEntity).toList());
    } on AppException catch (e) {
      try {
        final cachedTeams = await _localDataSource.getCachedTeams();
        if (cachedTeams.isNotEmpty) {
          return Right(cachedTeams.map(_toEntity).toList());
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> getTeamById(String id) async {
    try {
      final team = await _remoteDataSource.getTeamById(id);
      return Right(_toEntity(team));
    } on AppException catch (e) {
      try {
        final cachedTeams = await _localDataSource.getCachedTeams();
        final found = cachedTeams.where((t) => t.id == id);
        if (found.isNotEmpty) {
          return Right(_toEntity(found.first));
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  TeamEntity _toEntity(TeamModel model) {
    return TeamEntity(
      id: model.id,
      name: model.name,
      code: model.code,
      flag: model.flag,
      confederation: model.confederation,
      fifaRanking: model.fifaRanking,
      group: model.group,
      coach: model.coach,
      wins: model.wins,
      draws: model.draws,
      losses: model.losses,
      goalsFor: model.goalsFor,
      goalsAgainst: model.goalsAgainst,
      points: model.points,
    );
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
