import 'dart:io';

sealed class ProfileEvents {}

class GetProfileEvent extends ProfileEvents {}

class EditProfileEvent extends ProfileEvents {
  final Map<String, dynamic> body;
  EditProfileEvent({required this.body});
}

class UpdateProfilePhotoEvent extends ProfileEvents {
  final File file;
  UpdateProfilePhotoEvent({required this.file});
}

class ResetPasswordEvent extends ProfileEvents {
  final Map<String, dynamic> body;
  ResetPasswordEvent({required this.body});
}
