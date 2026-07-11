import 'package:track_flowers_app/features/main_profile/domain/entities/profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  String? vehicleLicense;

  ProfileModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.id,
    this.photo,
    this.gender,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      photo: entity.photo,
      gender: entity.gender,
      vehicleType: entity.vehicleType,
      vehicleNumber: entity.vehicleNumber,
      vehicleLicense: entity.vehicleLicense,
    );
  }
}
