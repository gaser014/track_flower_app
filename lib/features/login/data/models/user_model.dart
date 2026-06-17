import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
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
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "addresses")
  List? addresses;
  @JsonKey(name: "wishlist")
  List? wishlist;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.id,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      createdAt: createdAt,
      addresses: addresses,
      wishlist: wishlist,
      photo: photo,
      gender: gender,
    );
  }

  factory UserModel.fromUserEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
      createdAt: entity.createdAt,
    )
      ..addresses = entity.addresses
      ..wishlist = entity.wishlist
      ..photo = entity.photo
      ..gender = entity.gender;
  }
}
