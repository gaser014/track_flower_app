import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'dart:io';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';

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

class GetInitialDataEvent extends AuthModuleEvent {}

class ApplyDriverEvent extends AuthModuleEvent {
  final ApplyDriverParams params;

  ApplyDriverEvent(this.params);
}

class ChangeCountryEvent extends AuthModuleEvent {
  final CountryModel country;
  ChangeCountryEvent(this.country);
}

class ChangeVehicleEvent extends AuthModuleEvent {
  final VehicleTypeModel vehicle;
  ChangeVehicleEvent(this.vehicle);
}

class PickVehicleLicenseEvent extends AuthModuleEvent {
  final File file;
  PickVehicleLicenseEvent(this.file);
}

class PickNidImageEvent extends AuthModuleEvent {
  final File file;
  PickNidImageEvent(this.file);
}

class ChangeGenderEvent extends AuthModuleEvent {
  final String gender;
  ChangeGenderEvent(this.gender);
}