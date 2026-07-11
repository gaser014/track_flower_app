import 'dart:io';

import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:track_flowers_app/features/profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/profile/data/models/profile_data_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/data/models/upload_photo_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _apiClient;

  const ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ProfileDataResponseModel>> getProfileData() async {
    return await executeApi(() async {
      final response = await _apiClient.getProfileData();
      return response;
    });
  }

  @override
  Future<Result<ProfileDataResponseModel>> editProfile(
    EditProfileRequestModel request,
  ) async {
    return await executeApi(() async {
      final response = await _apiClient.editProfile(request);
      return response;
    });
  }

  @override
  Future<Result<UploadPhotoResponseModel>> uploadProfilePhoto(
    File photo,
  ) async {
    return await executeApi(() async {
      final response = await _apiClient.uploadProfilePhoto(photo);
      return response;
    });
  }

  @override
  Future<Result<void>> logout() async {
    return await executeApi(() async {
      await _apiClient.logout();
    });
  }

  @override
  Future<Result<void>> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    return await executeApi(() async {
      await _apiClient.changePassword(request);
    });
  }
}
