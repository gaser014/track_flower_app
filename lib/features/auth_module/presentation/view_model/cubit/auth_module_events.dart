import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';

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


// ─── Forget Password Events ───────────────────────────────────────────────────

class SendCodeEvent extends AuthModuleEvent {
  final ForgetPasswordParams params;
  SendCodeEvent({required this.params});
}

class VerifyCodeEvent extends AuthModuleEvent {
  final ForgetPasswordParams params;
  VerifyCodeEvent({required this.params});
}

class ResetPasswordEvent extends AuthModuleEvent {
  final ForgetPasswordParams params;
  ResetPasswordEvent({required this.params});
}
