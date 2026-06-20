import 'package:track_flowers_app/config/uses_cases/params.dart';

class DriverLoginRequestEntity extends Params {
  final String email;
  final String password;
  final bool? remember;

  const DriverLoginRequestEntity({
    required this.email,
    required this.password,
    this.remember,
  });

  @override
  List<Object?> get props => [email, password, remember];
}
