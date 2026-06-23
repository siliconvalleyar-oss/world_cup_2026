import 'package:freezed_annotation/freezed_annotation.dart';

import 'player_model.dart';

part 'lineups.freezed.dart';
part 'lineups.g.dart';

@freezed
class Lineups with _$Lineups {
  const factory Lineups({
    @Default([]) List<PlayerModel> homeLineup,
    @Default([]) List<PlayerModel> awayLineup,
    @Default([]) List<PlayerModel> homeSubstitutes,
    @Default([]) List<PlayerModel> awaySubstitutes,
    String? formation,
  }) = _Lineups;

  factory Lineups.fromJson(Map<String, dynamic> json) =>
      _$LineupsFromJson(json);
}
