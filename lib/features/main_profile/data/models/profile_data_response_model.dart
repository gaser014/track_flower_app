import 'package:track_flowers_app/features/login/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_data_response_model.g.dart';

@JsonSerializable()
class ProfileDataResponseModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  UserModel? user;

  ProfileDataResponseModel({this.message, this.user});

  factory ProfileDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataResponseModelToJson(this);
}
