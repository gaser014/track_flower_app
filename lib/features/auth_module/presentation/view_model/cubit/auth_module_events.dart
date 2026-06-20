import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';

sealed class AuthModuleEvent {}

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
