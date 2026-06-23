import 'dart:io';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/data/models/login_response_model.dart';

abstract interface class LoginRemoteDataSourceContract {
  Future<Result<LoginResponseModel>> login(LoginParams params);
  Future<Result<LoginResponseModel>> getProfile();
  Future<Result<LoginResponseModel>> editProfile(Map<String, dynamic> body);
  Future<Result<LoginResponseModel>> updateProfilePhoto(File file);
}
