import 'package:track_flowers_app/config/uses_cases/params.dart';

class SaveCredentialsRequestEntity extends Params {
  final String email;
  final String password;

  const SaveCredentialsRequestEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
