import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';

abstract interface class LoginRepositoryContract {
  Future<Result<LoginResponseEntity>> login(LoginParams params);
  Future<Result<UserEntity>> saveUser(UserEntity userEntity);
  Future<Result<UserEntity?>> getUser();
  Future<Result<LoginResponseEntity>> getProfile();
  Future<Result<LoginResponseEntity>> editProfile(Map<String, dynamic> body);
  Future<Result<LoginResponseEntity>> updateProfilePhoto(File file);
}
