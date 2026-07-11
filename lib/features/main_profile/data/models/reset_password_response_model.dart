import 'package:track_flowers_app/features/main_profile/domain/entities/reset_password_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_model.g.dart';

@JsonSerializable()
class ResetPasswordResponseModel {
  @JsonKey(name: "message")
  String? message;

  ResetPasswordResponseModel({this.message});

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseModelToJson(this);

  ResetPasswordResponseEntity toEntity() {
    return ResetPasswordResponseEntity(message: message);
  }
}
