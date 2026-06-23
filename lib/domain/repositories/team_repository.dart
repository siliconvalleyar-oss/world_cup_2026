import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/domain/entities/team_entity.dart';

abstract class TeamRepository {
  Future<Either<Failure, List<TeamEntity>>> getTeams({Map<String, dynamic>? queryParameters});
  Future<Either<Failure, TeamEntity>> getTeamById(String id);
}
