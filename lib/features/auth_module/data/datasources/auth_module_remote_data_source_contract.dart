import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';
import 'package:track_flowers_app/config/base_response/result.dart';

abstract interface class AuthModuleRemoteDataSourceContract {
  Future<Result<DriverLoginResponseModel>> loginDriver(
    DriverLoginRequestEntity params,
  );
  Future<Result<ForgetPasswordResponse>> sendForgetPasswordCode(
    ForgetPasswordRequest request,
  );

  Future<Result<ForgetPasswordResponse>> verifyForgetPasswordCode(
    VerifyCodeRequest request,
  );

  Future<Result<ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest request,
  );
  Future<Result<void>> logoutDriver();

}
