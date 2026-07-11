import 'dart:io';

import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> getProfileData() async {
    var response = await _remoteDataSource.getProfileData();
    return response.when(
      success: (data) {
        if (data?.user != null) {
          return Success(data: data!.user!.toUserEntity());
        }
        return Error(exception: Exception("User data is null"));
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<UserEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    var response = await _remoteDataSource.editProfile(request);
    return response.when(
      success: (data) {
        if (data?.user != null) {
          return Success(data: data!.user!.toUserEntity());
        }
        return Error(exception: Exception("User data is null"));
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<String>> uploadProfilePhoto(File photo) async {
    var response = await _remoteDataSource.uploadProfilePhoto(photo);
    return response.when(
      success: (data) {
        if (data?.photo != null) {
          return Success(data: data!.photo!);
        }
        return Error(exception: Exception("Photo upload failed"));
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<void>> logout() async {
    var response = await _remoteDataSource.logout();
    return response.when(
      success: (_) => const Success(data: null),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<void>> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    var response = await _remoteDataSource.changePassword(request);
    return response.when(
      success: (_) => const Success(data: null),
      error: (exception) => Error(exception: exception),
    );
  }
}
