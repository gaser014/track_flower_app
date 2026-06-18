
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';

class DriverLoginResponseEntity {
  final String? message;
  final String? token;
  final DriverEntity? driver;

  DriverLoginResponseEntity({this.message, this.token, this.driver});
}
