// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileRequestModel _$EditProfileRequestModelFromJson(
  Map<String, dynamic> json,
) => EditProfileRequestModel(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  gender: json['gender'] as String,
);

Map<String, dynamic> _$EditProfileRequestModelToJson(
  EditProfileRequestModel instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'gender': instance.gender,
};
