import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/reset_password_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/profile_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthModuleRepository)
class AuthModuleRepositoryImpl implements AuthModuleRepository {
  final AuthModuleRemoteDataSourceContract _remoteDataSource;
  final AuthModuleLocalDataSourceContract _localDataSource;

  AuthModuleRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<ProfileResponseEntity>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.when(
      success: (response) {
        final user = response?.user;
        final profile = user == null
            ? null
            : ProfileEntity(
                id: user.id,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                photo: user.photo,
                gender: user.gender,
                vehicleType: user.vehicleType,
                vehicleNumber: user.vehicleNumber,
                vehicleLicense: user.vehicleLicense,
              );
        return Success(
          data: ProfileResponseEntity(message: response?.message, profile: profile),
        );
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<ProfileResponseEntity>> editProfile(Map<String, dynamic> body) async {
    final result = await _remoteDataSource.editProfile(body);
    return result.when(
      success: (response) {
        final user = response?.user;
        final profile = user == null
            ? null
            : ProfileEntity(
                id: user.id,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                photo: user.photo,
                gender: user.gender,
                vehicleType: user.vehicleType,
                vehicleNumber: user.vehicleNumber,
                vehicleLicense: user.vehicleLicense,
              );
        return Success(
          data: ProfileResponseEntity(message: response?.message, profile: profile),
        );
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<ProfileResponseEntity>> updateProfilePhoto(File file) async {
    final result = await _remoteDataSource.updateProfilePhoto(file);
    return result.when(
      success: (response) {
        final user = response?.user;
        final profile = user == null
            ? null
            : ProfileEntity(
                id: user.id,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                photo: user.photo,
                gender: user.gender,
                vehicleType: user.vehicleType,
                vehicleNumber: user.vehicleNumber,
                vehicleLicense: user.vehicleLicense,
              );
        return Success(
          data: ProfileResponseEntity(message: response?.message, profile: profile),
        );
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<ResetPasswordResponseEntity>> resetPassword(Map<String, dynamic> body) async {
    final result = await _remoteDataSource.resetPassword(body);
    return result.when(
      success: (response) {
        return Success(
          data: response?.toEntity() ?? ResetPasswordResponseEntity(),
        );
      },
      error: (exception) => Error(exception: exception),
    );
  }
}
