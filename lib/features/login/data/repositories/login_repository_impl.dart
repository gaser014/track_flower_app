import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/login/data/datasources/login_local_data_source_contract.dart';
import 'package:track_flowers_app/features/login/data/datasources/login_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/login/data/models/user_model.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepositoryContract)
class LoginRepositoryImpl implements LoginRepositoryContract {
  final LoginRemoteDataSourceContract _loginRemoteDataSourceContract;
  final LoginLocalDataSourceContract _loginLocalDataSourceContract;
  const LoginRepositoryImpl(
    this._loginRemoteDataSourceContract,
    this._loginLocalDataSourceContract,
  );

  @override
  Future<Result<LoginResponseEntity>> login(LoginParams params) async {
    final result = await _loginRemoteDataSourceContract.login(params);
    return result.when(
      success: (response) {
        LoginResponseEntity? loginResponseEntity = response?.toEntity();
        return Success<LoginResponseEntity>(data: loginResponseEntity);
      },
      error: (error) {
        return Error(exception: error);
      },
    );
  }

  @override
  Future<Result<UserEntity>> saveUser(UserEntity userEntity) async {
    try {
      final userModel = UserModel.fromUserEntity(userEntity);
      final savedModel = await _loginLocalDataSourceContract.saveUser(
        userModel,
      );
      return Success<UserEntity>(data: savedModel.toUserEntity());
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  @override
  Future<Result<UserEntity?>> getUser() async {
    try {
      final userModel = await _loginLocalDataSourceContract.getUser();
      return Success<UserEntity?>(data: userModel?.toUserEntity());
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  @override
  Future<Result<LoginResponseEntity>> getProfile() async {
    final result = await _loginRemoteDataSourceContract.getProfile();
    return result.when(
      success: (response) {
        LoginResponseEntity? loginResponseEntity = response?.toEntity();
        return Success<LoginResponseEntity>(data: loginResponseEntity);
      },
      error: (error) {
        return Error(exception: error);
      },
    );
  }

  @override
  Future<Result<LoginResponseEntity>> editProfile(Map<String, dynamic> body) async {
    final result = await _loginRemoteDataSourceContract.editProfile(body);
    return result.when(
      success: (response) {
        LoginResponseEntity? loginResponseEntity = response?.toEntity();
        return Success<LoginResponseEntity>(data: loginResponseEntity);
      },
      error: (error) {
        return Error(exception: error);
      },
    );
  }

  @override
  Future<Result<LoginResponseEntity>> updateProfilePhoto(File file) async {
    final result = await _loginRemoteDataSourceContract.updateProfilePhoto(file);
    return result.when(
      success: (response) {
        LoginResponseEntity? loginResponseEntity = response?.toEntity();
        return Success<LoginResponseEntity>(data: loginResponseEntity);
      },
      error: (error) {
        return Error(exception: error);
      },
    );
  }
}
