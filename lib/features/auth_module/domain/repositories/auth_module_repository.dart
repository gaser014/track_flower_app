import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/reset_password_response_entity.dart';

abstract class AuthModuleRepository {
  Future<Result<ProfileResponseEntity>> getProfile();
  Future<Result<ProfileResponseEntity>> editProfile(Map<String, dynamic> body);
  Future<Result<ProfileResponseEntity>> updateProfilePhoto(File file);
  Future<Result<ResetPasswordResponseEntity>> resetPassword(Map<String, dynamic> body);
}
