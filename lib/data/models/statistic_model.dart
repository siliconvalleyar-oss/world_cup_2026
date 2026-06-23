import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistic_model.freezed.dart';
part 'statistic_model.g.dart';

@freezed
class StatisticModel with _$StatisticModel {
  const factory StatisticModel({
    required String id,
    required String type,
    required dynamic value,
    String? playerId,
    String? teamId,
  }) = _StatisticModel;

  factory StatisticModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticModelFromJson(json);
}
