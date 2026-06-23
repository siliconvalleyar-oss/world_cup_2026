import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/app_exception.dart';
import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/datasources/remote/player_remote_datasource.dart';
import 'package:world_cup_2026/data/models/player_model.dart';
import 'package:world_cup_2026/domain/entities/player_entity.dart';
import 'package:world_cup_2026/domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource _remoteDataSource;

  PlayerRepositoryImpl({
    required PlayerRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final players = await _remoteDataSource.getPlayers(
        queryParameters: queryParameters,
      );
      return Right(players.map(_toEntity).toList());
    } on AppException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> getPlayerById(String id) async {
    try {
      final player = await _remoteDataSource.getPlayerById(id);
      return Right(_toEntity(player));
    } on AppException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> getPlayersByTeam(
    String teamId,
  ) async {
    try {
      final players = await _remoteDataSource.getPlayersByTeam(teamId);
      return Right(players.map(_toEntity).toList());
    } on AppException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  PlayerEntity _toEntity(PlayerModel model) {
    return PlayerEntity(
      id: model.id,
      name: model.name,
      position: model.position,
      number: model.number,
      age: model.age,
      nationality: model.nationality,
      teamId: model.teamId,
      teamName: model.teamName,
      photo: model.photo,
      goals: model.goals,
      assists: model.assists,
      minutesPlayed: model.minutesPlayed,
      yellowCards: model.yellowCards,
      redCards: model.redCards,
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
