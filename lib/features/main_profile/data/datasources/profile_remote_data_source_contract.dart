import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/data/models/login_response_model.dart';
import 'package:track_flowers_app/features/main_profile/data/models/reset_password_response_model.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<Result<LoginResponseModel>> getProfile();
  Future<Result<LoginResponseModel>> editProfile(Map<String, dynamic> body);
  Future<Result<LoginResponseModel>> updateProfilePhoto(File file);
  Future<Result<ResetPasswordResponseModel>> resetPassword(Map<String, dynamic> body);
}
