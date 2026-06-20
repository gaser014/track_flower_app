import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  @JsonKey(name: "id")
  final String? id;
  
  @JsonKey(name: "first_name")
  final String? firstName;
  
  @JsonKey(name: "last_name")
  final String? lastName;
  
  @JsonKey(name: "email")
  final String? email;
  
  @JsonKey(name: "phone")
  final String? phone;
  
  @JsonKey(name: "photo")
  final String? photo;
  
  @JsonKey(name: "role")
  final String? role;
  
  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  DriverModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
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
      photo: photo,
      role: role,
      createdAt: createdAt,
    );
  }
}
