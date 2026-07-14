import 'dart:io';

import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/profile/data/models/profile_data_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/data/models/upload_photo_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<Result<ProfileDataResponseModel>> getProfileData();

  Future<Result<ProfileDataResponseModel>> editProfile(
    EditProfileRequestModel request,
  );

  Future<Result<UploadPhotoResponseModel>> uploadProfilePhoto(File photo);

  Future<Result<void>> logout();

  Future<Result<void>> changePassword(ChangePasswordRequestModel request);
}
