import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/domain/entities/match_entity.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<MatchEntity>>> getMatches({Map<String, dynamic>? queryParameters});
  Future<Either<Failure, MatchEntity>> getMatchById(String id);
  Future<Either<Failure, List<MatchEntity>>> getLiveMatches();
  Future<Either<Failure, List<MatchEntity>>> getMatchesByGroup(String group);
}
