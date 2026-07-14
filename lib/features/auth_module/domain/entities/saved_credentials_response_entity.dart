import 'package:track_flowers_app/config/uses_cases/params.dart';

class SavedCredentialsResponseEntity extends Params {
  final String? email;
  final String? password;

  const SavedCredentialsResponseEntity({
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
