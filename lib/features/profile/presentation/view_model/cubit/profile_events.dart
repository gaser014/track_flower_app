import 'dart:io';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';

import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';

sealed class ProfileEvents {}

class GetProfileEvent extends ProfileEvents {}

class EditProfileEvent extends ProfileEvents {
  final EditProfileRequestModel request;
  EditProfileEvent(this.request);
}

class UploadProfilePhotoEvent extends ProfileEvents {
  final File photo;
  UploadProfilePhotoEvent(this.photo);
}

class ToggleGenderEvent extends ProfileEvents {
  final String gender;
  ToggleGenderEvent(this.gender);
}

class TogglePasswordVisibilityEvent extends ProfileEvents {}

class LogoutEvent extends ProfileEvents {}

class ChangePasswordEvent extends ProfileEvents {
  final ChangePasswordRequestModel request;
  ChangePasswordEvent(this.request);
}

