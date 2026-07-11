import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_response_model.g.dart';

@JsonSerializable()
class UploadPhotoResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "photo")
  final String? photo;

  UploadPhotoResponseModel({
    this.message,
    this.photo,
  });

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseModelToJson(this);
}
