import 'package:dartz/dartz.dart';

import 'package:world_cup_2026/core/errors/failure.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';

abstract class StandingRepository {
  Future<Either<Failure, List<GroupModel>>> getGroups();
  Future<Either<Failure, List<StandingModel>>> getStandings();
}
