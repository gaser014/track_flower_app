import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@Injectable(as: AuthModuleRepository)
class AuthModuleRepositoryImpl implements AuthModuleRepository {
  final AuthModuleRemoteDataSourceContract _remoteDataSource;

  const AuthModuleRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> sendForgetPasswordCode(
    ForgetPasswordParams params,
  ) async {
    final result = await _remoteDataSource.sendForgetPasswordCode(
      ForgetPasswordRequest(email: params.email ?? ''),
    );
    return result.makeDummyData(
      dummyData: const Success<void>(),
      success: (_) => const Success<void>(),
      error: (e) => Error<void>(exception: e),
    );
  }

  @override
  Future<Result<void>> verifyForgetPasswordCode(
    ForgetPasswordParams params,
  ) async {
    final result = await _remoteDataSource.verifyForgetPasswordCode(
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
    final result = await _remoteDataSource.resetPassword(
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
}
