import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';

@Injectable(as: AuthModuleRemoteDataSourceContract)
class AuthModuleRemoteDataSourceImpl
    implements AuthModuleRemoteDataSourceContract {
  final AuthModuleApiClient _apiClient;
  const AuthModuleRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ForgetPasswordResponse>> sendForgetPasswordCode(
    ForgetPasswordRequest request,
  ) =>
      executeApi(() => _apiClient.sendForgetPasswordCode(request));

  @override
  Future<Result<ForgetPasswordResponse>> verifyForgetPasswordCode(
    VerifyCodeRequest request,
  ) =>
      executeApi(() => _apiClient.verifyForgetPasswordCode(request));

  @override
  Future<Result<ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest request,
  ) =>
      executeApi(() => _apiClient.resetPassword(request));

  @override
  Future<Result<DriverLoginResponseModel>> loginDriver(
    DriverLoginRequestEntity params,
  ) async {
    return await executeApi(() async {
      final response = await _apiClient.loginDriver(params.email, params.password);
      return DriverLoginResponseModel.fromJson(response as Map<String, dynamic>);
    });
  }
}
