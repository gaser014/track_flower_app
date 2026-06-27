import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel extends LocationEntity {
  const LocationModel({
    required super.lat,
    required super.lng,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(lat: entity.lat, lng: entity.lng);
  }
}
