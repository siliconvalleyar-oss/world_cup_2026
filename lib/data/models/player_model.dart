import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required String id,
    required String name,
    String? position,
    int? number,
    int? age,
    String? nationality,
    String? teamId,
    String? teamName,
    String? photo,
    @Default(0) int goals,
    @Default(0) int assists,
    @Default(0) int minutesPlayed,
    @Default(0) int yellowCards,
    @Default(0) int redCards,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
