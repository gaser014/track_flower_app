
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/saved_credentials_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/config/error_handling/failures.dart';


@Injectable(as: AuthModuleRepository)
class AuthModuleRepositoryImpl implements AuthModuleRepository {
  final AuthModuleRemoteDataSourceContract _remote;
  final AuthModuleLocalDataSourceContract _local;

  const AuthModuleRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<void>> sendForgetPasswordCode(
    ForgetPasswordParams params,
  ) async {
    final result = await _remote.sendForgetPasswordCode(
      ForgetPasswordRequest(email: params.email ?? ''),
    );
    return result.makeDummyData(
      dummyData: const Success<void>(),
      success: (_) => const Success<void>(),
      error: (e) => Error<void>(exception: e),
    );
  }

  @override
  Future<Result<DriverLoginResponseEntity>> loginDriver(
    DriverLoginRequestEntity params,
  ) async {
    final result = await _remote.loginDriver(params);
    return result.when(
      success: (response) {
        return Success<DriverLoginResponseEntity>(
          data: response?.toEntity(),
        );
      },
      error: (error) => Error(exception: error),
    );
  }

  @override
  Future<Result<void>> verifyForgetPasswordCode(
    ForgetPasswordParams params,
  ) async {
    final result = await _remote.verifyForgetPasswordCode(
      VerifyCodeRequest(resetCode: params.resetCode ?? ''),
    );
    return result.makeDummyData(
      dummyData: const Success<void>(),
      success: (_) => const Success<void>(),
      error: (e) => Error<void>(exception: e),
    );
  }

  @override
  Future<Result<void>> resetPassword(ForgetPasswordParams params) async {
    final result = await _remote.resetPassword(
      ResetPasswordRequest(
        email: params.email ?? '',
        newPassword: params.newPassword ?? '',
      ),
    );
    return result.makeDummyData(
      dummyData: const Success<void>(),
      success: (_) => const Success<void>(),
      error: (e) => Error<void>(exception: e),
    );
  }

  @override
  Future<Result<void>> saveDriverToken(String token) async {
    try {
      await _local.saveDriverToken(token);
      return const Success(data: null);
    } catch (e) {
      return Error(exception: CacheFailures(errorMessage: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteDriverToken() async {
    try {
      await _local.deleteDriverToken();
      return const Success(data: null);
    } catch (e) {
      return Error(exception: CacheFailures(errorMessage: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveCredentials(SaveCredentialsRequestEntity request) async {
    try {
      await _local.saveCredentials(request);
      return const Success(data: null);
    } catch (e) {
      return Error(exception: CacheFailures(errorMessage: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteCredentials() async {
    try {
      await _local.deleteCredentials();
      return const Success(data: null);
    } catch (e) {
      return Error(exception: CacheFailures(errorMessage: e.toString()));
    }
  }

  @override
  Future<Result<SavedCredentialsResponseEntity>> getSavedCredentials() async {
    try {
      final credentials = await _local.getSavedCredentials();
      return Success(data: SavedCredentialsResponseEntity(
        email: credentials['email'],
        password: credentials['password'],
      ));
    } catch (e) {
      return Error(exception: CacheFailures(errorMessage: e.toString()));
    }
  }
}
