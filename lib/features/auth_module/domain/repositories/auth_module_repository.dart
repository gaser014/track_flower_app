
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/base_response/result.dart';

abstract interface class AuthModuleRepository {
  Future<Result<DriverLoginResponseEntity>> loginDriver(DriverLoginRequestEntity params);
  Future<Result<void>> saveDriverToken(String token);
  Future<Result<void>> deleteDriverToken();
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  });
  Future<Result<void>> deleteCredentials();
  Future<Result<Map<String, String?>>> getSavedCredentials();
  Future<Result<void>> sendForgetPasswordCode(ForgetPasswordParams params);

  Future<Result<void>> verifyForgetPasswordCode(ForgetPasswordParams params);

  Future<Result<void>> resetPassword(ForgetPasswordParams params);
  Future<Result<void>> logoutDriver();

  // Local — token
  Future<Result<void>> saveDriverToken(String token);
  Future<Result<void>> deleteDriverToken();

  // Local — credentials
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  });
  Future<Result<void>> deleteCredentials();
  Future<Result<Map<String, String?>>> getSavedCredentials();

}
