import 'dart:io';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';

sealed class LoginEvents {}

class LoginEvent extends LoginEvents {
  final LoginParams params;
  LoginEvent({required this.params});
}

class RememberMeEvent extends LoginEvents {
  final bool rememberMe;
  RememberMeEvent({required this.rememberMe});
}

class ShowPasswordEvent extends LoginEvents {
  final bool showPassword;
  ShowPasswordEvent({required this.showPassword});
}

class GetProfileEvent extends LoginEvents {}

class EditProfileEvent extends LoginEvents {
  final Map<String, dynamic> body;
  EditProfileEvent({required this.body});
}

class UpdateProfilePhotoEvent extends LoginEvents {
  final File file;
  UpdateProfilePhotoEvent({required this.file});
}
