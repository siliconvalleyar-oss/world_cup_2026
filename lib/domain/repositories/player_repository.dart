import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/domain/entities/player_entity.dart';

abstract class PlayerRepository {
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({Map<String, dynamic>? queryParameters});
  Future<Either<Failure, PlayerEntity>> getPlayerById(String id);
  Future<Either<Failure, List<PlayerEntity>>> getPlayersByTeam(String teamId);
}
