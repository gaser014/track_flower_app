import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';

class DriverLoginResponseEntity {
  final String? message;
  final String? token;
  final DriverEntity? driver;

  DriverLoginResponseEntity({this.message, this.token, this.driver});

  factory DriverLoginResponseEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DriverLoginResponseEntity();
    return DriverLoginResponseEntity(
      message: json['message']?.toString(),
      token: json['token']?.toString(),
      driver: json['driver'] != null ? DriverEntity.fromJson(json['driver'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'driver': driver?.toJson(),
    };
  }
}
