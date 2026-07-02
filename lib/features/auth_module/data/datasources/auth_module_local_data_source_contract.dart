import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';

abstract interface class AuthModuleLocalDataSourceContract {
  Future<void> saveDriverToken(String token);
  Future<void> deleteDriverToken();
  Future<void> saveCredentials(SaveCredentialsRequestEntity request);
  Future<void> deleteCredentials();
  Future<Map<String, String?>> getSavedCredentials();
}
