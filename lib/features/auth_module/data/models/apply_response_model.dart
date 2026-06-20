import 'package:json_annotation/json_annotation.dart';

part 'apply_response_model.g.dart';

@JsonSerializable()
class ApplyResponseModel {
  @JsonKey(name: "message")
  final String? message;

  ApplyResponseModel({
    this.message,
  });

  factory ApplyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyResponseModelToJson(this);
}
