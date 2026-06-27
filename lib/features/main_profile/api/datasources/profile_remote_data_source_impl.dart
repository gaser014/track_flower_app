import 'dart:io';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/main_profile/api/api_client/profile_api_client.dart';
import 'package:track_flowers_app/features/main_profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/login/data/models/login_response_model.dart';
import 'package:track_flowers_app/features/main_profile/data/models/reset_password_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<LoginResponseModel>> getProfile() async {
    return await executeApi(() async {
      final response = await _apiClient.getProfile();
      return response;
    });
  }

  @override
  Future<Result<LoginResponseModel>> editProfile(Map<String, dynamic> body) async {
    return await executeApi(() async {
      final response = await _apiClient.editProfile(body);
      return response;
    });
  }

  @override
  Future<Result<LoginResponseModel>> updateProfilePhoto(File file) async {
    return await executeApi(() async {
      final response = await _apiClient.updateProfilePhoto(file);
      return response;
    });
  }

  @override
  Future<Result<ResetPasswordResponseModel>> resetPassword(Map<String, dynamic> body) async {
    return await executeApi(() async {
      final response = await _apiClient.resetPassword(body);
      return response;
    });
  }
}
