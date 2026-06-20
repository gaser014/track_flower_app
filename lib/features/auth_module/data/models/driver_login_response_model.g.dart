// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverLoginResponseModel _$DriverLoginResponseModelFromJson(
  Map<String, dynamic> json,
) => DriverLoginResponseModel(
  message: json['message'] as String?,
  token: json['token'] as String?,
  driver: json['driver'] == null
      ? null
      : DriverModel.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DriverLoginResponseModelToJson(
  DriverLoginResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'token': instance.token,
  'driver': instance.driver,
};
