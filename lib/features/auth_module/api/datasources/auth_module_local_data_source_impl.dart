import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthModuleLocalDataSourceContract)
class AuthModuleLocalDataSourceImpl
    implements AuthModuleLocalDataSourceContract {
  @override
  Future<void> saveDriverToken(String token) async {
    await AppSharedPreferences.setString(
      key: AppStrings.driverToken,
      value: token,
    );
  }

  @override
  Future<void> deleteDriverToken() async {
    await AppSharedPreferences.remove(key: AppStrings.driverToken);
  }

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await AppSharedPreferences.setString(
      key: AppStrings.driverSavedEmail,
      value: email,
    );
    await AppSharedPreferences.setString(
      key: AppStrings.driverSavedPassword,
      value: password,
    );
  }

  @override
  Future<void> deleteCredentials() async {
    await AppSharedPreferences.remove(key: AppStrings.driverSavedEmail);
    await AppSharedPreferences.remove(key: AppStrings.driverSavedPassword);
  }

  @override
  Future<Map<String, String?>> getSavedCredentials() async {
    final email = await AppSharedPreferences.getString(
      key: AppStrings.driverSavedEmail,
    );
    final password = await AppSharedPreferences.getString(
      key: AppStrings.driverSavedPassword,
    );
    return {
      AppStrings.driverSavedEmail: email,
      AppStrings.driverSavedPassword: password,
    };
  }
}
