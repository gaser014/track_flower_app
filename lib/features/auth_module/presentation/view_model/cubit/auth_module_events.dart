import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';

sealed class AuthModuleEvent {}


class LoginEvent extends AuthModuleEvent {
  final DriverLoginRequestEntity params;
  LoginEvent({required this.params});
}

class RememberMeEvent extends AuthModuleEvent {
  final bool rememberMe;
  RememberMeEvent({required this.rememberMe});
}

class ShowPasswordEvent extends AuthModuleEvent {
  final bool showPassword;
  ShowPasswordEvent({required this.showPassword});
}

class LogoutEvent extends AuthModuleEvent {}

