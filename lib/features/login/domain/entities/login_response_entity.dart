import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';

class LoginResponseEntity {
  final String? message;
  final String? token;
  final UserEntity? user;

  LoginResponseEntity({this.message, this.token, this.user});
}
