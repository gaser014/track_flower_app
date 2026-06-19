import 'package:json_annotation/json_annotation.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'role')
  final String? role;

  const DriverModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
    );
  }
}
