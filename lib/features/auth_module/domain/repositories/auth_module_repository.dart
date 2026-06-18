
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';

abstract interface class AuthModuleRepository {
  Future<Result<DriverLoginResponseEntity>> loginDriver(LoginParams params);
  Future<Result<void>> saveDriverToken(String token);
  Future<Result<void>> deleteDriverToken();
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  });
  Future<Result<void>> deleteCredentials();
  Future<Result<Map<String, String?>>> getSavedCredentials();
}
