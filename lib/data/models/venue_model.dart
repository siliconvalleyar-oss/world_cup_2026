import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

@freezed
class VenueModel with _$VenueModel {
  const factory VenueModel({
    required String id,
    required String name,
    required String city,
    String? country,
    int? capacity,
    double? latitude,
    double? longitude,
    String? image,
    String? fifaName,
    String? region,
  }) = _VenueModel;

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);
}
