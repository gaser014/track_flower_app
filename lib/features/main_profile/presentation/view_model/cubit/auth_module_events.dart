import 'dart:io';

sealed class AuthModuleEvents {}

class GetProfileEvent extends AuthModuleEvents {}

class EditProfileEvent extends AuthModuleEvents {
  final Map<String, dynamic> body;
  EditProfileEvent({required this.body});
}

class UpdateProfilePhotoEvent extends AuthModuleEvents {
  final File file;
  UpdateProfilePhotoEvent({required this.file});
}

class ResetPasswordEvent extends AuthModuleEvents {
  final Map<String, dynamic> body;
  ResetPasswordEvent({required this.body});
}
