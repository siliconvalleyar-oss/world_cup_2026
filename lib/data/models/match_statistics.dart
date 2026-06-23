import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_statistics.freezed.dart';
part 'match_statistics.g.dart';

@freezed
class MatchStatistics with _$MatchStatistics {
  const factory MatchStatistics({
    @Default(0.0) double possessionHome,
    @Default(0.0) double possessionAway,
    @Default(0) int shotsHome,
    @Default(0) int shotsAway,
    @Default(0) int shotsOnTargetHome,
    @Default(0) int shotsOnTargetAway,
    @Default(0) int foulsHome,
    @Default(0) int foulsAway,
    @Default(0) int cornersHome,
    @Default(0) int cornersAway,
    @Default(0) int offsidesHome,
    @Default(0) int offsidesAway,
    @Default(0) int yellowCardsHome,
    @Default(0) int yellowCardsAway,
    @Default(0) int redCardsHome,
    @Default(0) int redCardsAway,
  }) = _MatchStatistics;

  factory MatchStatistics.fromJson(Map<String, dynamic> json) =>
      _$MatchStatisticsFromJson(json);
}
