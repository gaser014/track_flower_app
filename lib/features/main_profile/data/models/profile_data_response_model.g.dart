// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDataResponseModel _$ProfileDataResponseModelFromJson(
  Map<String, dynamic> json,
) => ProfileDataResponseModel(
  message: json['message'] as String?,
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDataResponseModelToJson(
  ProfileDataResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'user': instance.user};
