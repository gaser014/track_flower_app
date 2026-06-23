import 'package:track_flowers_app/features/auth_module/data/models/profile_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/profile_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  ProfileModel? profile;

  ProfileResponseModel({this.message, this.profile});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
  
  ProfileResponseEntity toEntity() {
    return ProfileResponseEntity(
      message: message,
      profile: profile?.toEntity(),
    );
  }
}
