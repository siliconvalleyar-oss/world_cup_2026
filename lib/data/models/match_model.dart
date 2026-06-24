import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_model.dart';
import 'match_statistics.dart';
import 'lineups.dart';
import 'team_model.dart';
import 'venue_model.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String homeTeamId,
    required String awayTeamId,
    TeamModel? homeTeam,
    TeamModel? awayTeam,
    @Default(0) int homeScore,
    @Default(0) int awayScore,
    @Default('scheduled') String status,
    int? matchday,
    String? group,
    @Default('group_stage') String stage,
    VenueModel? venue,
    String? referee,
    required DateTime date,
    String? time,
    List<EventModel>? events,
    MatchStatistics? statistics,
    Lineups? lineups,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}
