import 'package:json_annotation/json_annotation.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_login_response_model.g.dart';

@JsonSerializable()
class DriverLoginResponseModel {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "token")
  final String? token;

  @JsonKey(name: "driver")
  final DriverModel? driver;

  DriverLoginResponseModel({this.message, this.token, this.driver});

  factory DriverLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DriverLoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLoginResponseModelToJson(this);

  DriverLoginResponseEntity toEntity() {
    return DriverLoginResponseEntity(
      message: message,
      token: token,
      driver: driver?.toEntity(),
    );
  }
}
