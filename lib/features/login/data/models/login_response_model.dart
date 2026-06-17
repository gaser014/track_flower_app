import 'package:track_flowers_app/features/login/data/models/user_model.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "token")
  String? token;
  @JsonKey(name: "user")
  UserModel? user;

  LoginResponseModel({this.message, this.token, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      message: message,
      token: token,
      user: user?.toUserEntity(),
    );
  }
}
