import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/datasources/local/match_local_datasource.dart';
import 'package:world_cup_2026/data/datasources/remote/match_remote_datasource.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/domain/entities/match_entity.dart';
import 'package:world_cup_2026/domain/repositories/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource _remoteDataSource;
  final MatchLocalDataSource _localDataSource;

  MatchRepositoryImpl({
    required MatchRemoteDataSource remoteDataSource,
    required MatchLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final matches = await _remoteDataSource.getMatches(
        queryParameters: queryParameters,
      );
      await _localDataSource.cacheMatches(matches);
      return Right(matches.map(_toEntity).toList());
    } on AppException catch (e) {
      try {
        final cachedMatches = await _localDataSource.getCachedMatches();
        if (cachedMatches.isNotEmpty) {
          return Right(cachedMatches.map(_toEntity).toList());
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatchById(String id) async {
    try {
      final match = await _remoteDataSource.getMatchById(id);
      await _localDataSource.cacheMatch(match);
      return Right(_toEntity(match));
    } on AppException catch (e) {
      try {
        final cachedMatch = await _localDataSource.getCachedMatch(id);
        if (cachedMatch != null) {
          return Right(_toEntity(cachedMatch));
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getLiveMatches() async {
    try {
      final matches = await _remoteDataSource.getLiveMatches();
      return Right(matches.map(_toEntity).toList());
    } on AppException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatchesByGroup(
    String group,
  ) async {
    try {
      final matches = await _remoteDataSource.getMatchesByGroup(group);
      return Right(matches.map(_toEntity).toList());
    } on AppException catch (e) {
      try {
        final cachedMatches = await _localDataSource.getCachedMatches();
        final filtered = cachedMatches.where((m) => m.group == group).toList();
        if (filtered.isNotEmpty) {
          return Right(filtered.map(_toEntity).toList());
        }
      } catch (_) {}
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  MatchEntity _toEntity(MatchModel model) {
    return MatchEntity(
      id: model.id,
      homeTeamId: model.homeTeamId,
      awayTeamId: model.awayTeamId,
      homeTeamName: model.homeTeam?.name,
      awayTeamName: model.awayTeam?.name,
      homeScore: model.homeScore,
      awayScore: model.awayScore,
      status: model.status,
      matchday: model.matchday,
      group: model.group,
      venueName: model.venue?.name,
      venueCity: model.venue?.city,
      referee: model.referee,
      date: model.date,
      time: model.time,
      events: model.events
              ?.map((e) => EventEntity(
                    id: e.id,
                    type: e.type,
                    minute: e.minute,
                    playerId: e.playerId,
                    playerName: e.playerName,
                    teamId: e.teamId,
                    description: e.description,
                    extraTime: e.extraTime,
                  ))
              .toList() ??
          [],
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
