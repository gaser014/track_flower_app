import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/config/database/secure_storage_helper.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthModuleLocalDataSourceContract)
class AuthModuleLocalDataSourceImpl
    implements AuthModuleLocalDataSourceContract {
  @override
  Future<void> saveDriverToken(String token) async {
    await AppSecureStorage.setString(
      key: AppStrings.driverToken,
      value: token,
    );
  }

  @override
  Future<void> deleteDriverToken() async {
    await AppSecureStorage.remove(key: AppStrings.driverToken);
  }

  @override
  Future<void> saveCredentials(SaveCredentialsRequestEntity request) async {
    await AppSecureStorage.setString(
      key: AppStrings.driverSavedEmail,
      value: request.email,
    );
    await AppSecureStorage.setString(
      key: AppStrings.driverSavedPassword,
      value: request.password,
    );
  }

  @override
  Future<void> deleteCredentials() async {
    await AppSecureStorage.remove(key: AppStrings.driverSavedEmail);
    await AppSecureStorage.remove(key: AppStrings.driverSavedPassword);
  }

  @override
  Future<Map<String, String?>> getSavedCredentials() async {
    final email = await AppSecureStorage.getString(
      key: AppStrings.driverSavedEmail,
    );
    final password = await AppSecureStorage.getString(
      key: AppStrings.driverSavedPassword,
    );
    return {
      AppStrings.driverSavedEmail: email,
      AppStrings.driverSavedPassword: password,
    };
  }
}
