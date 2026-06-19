import 'package:track_flowers_app/config/base_response/result.dart';

abstract interface class AuthModuleRepository {
  // Remote
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
