import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';

abstract interface class AuthModuleRepository {
  Future<Result<void>> sendForgetPasswordCode(ForgetPasswordParams params);

  Future<Result<void>> verifyForgetPasswordCode(ForgetPasswordParams params);

  Future<Result<void>> resetPassword(ForgetPasswordParams params);
}
