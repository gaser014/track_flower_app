import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';

class DriverLoginResponseEntity extends Equatable {
  final String? message;
  final String? token;
  final DriverEntity? driver;

  const DriverLoginResponseEntity({this.message, this.token, this.driver});

  @override
  List<Object?> get props => [message, token, driver];
}
