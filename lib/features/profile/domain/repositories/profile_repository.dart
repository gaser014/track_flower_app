import 'dart:io';

import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';

import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';

abstract class ProfileRepositoryContract {
  Future<Result<UserEntity>> getProfileData();
  Future<Result<UserEntity>> editProfile(EditProfileRequestModel request);
  Future<Result<String>> uploadProfilePhoto(File photo);
  Future<Result<void>> logout();
  Future<Result<void>> changePassword(ChangePasswordRequestModel request);
}
