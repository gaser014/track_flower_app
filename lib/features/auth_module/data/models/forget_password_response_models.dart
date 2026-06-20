import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_models.g.dart';

@JsonSerializable()
class ForgetPasswordResponse {
  final String? statusMsg;
  final String? message;

  ForgetPasswordResponse({this.statusMsg, this.message});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseToJson(this);
}

@JsonSerializable()
class ResetPasswordResponse {
  final String? message;
  final String? token;

  ResetPasswordResponse({this.message, this.token});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}
