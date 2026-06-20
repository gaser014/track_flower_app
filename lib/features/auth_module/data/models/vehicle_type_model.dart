import 'package:json_annotation/json_annotation.dart';

part 'vehicle_type_model.g.dart';

@JsonSerializable()
class VehicleResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final dynamic metadata;
  @JsonKey(name: "vehicles")
  final List<VehicleTypeModel>? vehicles;

  VehicleResponseModel({
    this.message,
    this.metadata,
    this.vehicles,
  });

  factory VehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleResponseModelToJson(this);
}

@JsonSerializable()
class VehicleTypeModel {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "image")
  final String? image;

  VehicleTypeModel({
    this.id,
    this.type,
    this.image,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeModelToJson(this);
}
