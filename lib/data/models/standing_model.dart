import 'package:freezed_annotation/freezed_annotation.dart';

import 'team_model.dart';

part 'standing_model.freezed.dart';
part 'standing_model.g.dart';

@freezed
class StandingModel with _$StandingModel {
  const factory StandingModel({
    required String teamId,
    TeamModel? team,
    @Default(0) int played,
    @Default(0) int won,
    @Default(0) int drawn,
    @Default(0) int lost,
    @Default(0) int goalsFor,
    @Default(0) int goalsAgainst,
    @Default(0) int goalDifference,
    @Default(0) int points,
    @Default(0) int position,
  }) = _StandingModel;

  factory StandingModel.fromJson(Map<String, dynamic> json) =>
      _$StandingModelFromJson(json);
}
