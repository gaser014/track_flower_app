import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String resetCode;

  VerifyCodeRequest({required this.resetCode});

  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
