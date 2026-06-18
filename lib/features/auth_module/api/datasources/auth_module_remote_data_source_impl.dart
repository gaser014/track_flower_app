import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
// TODO: Replace with the actual model once it's provided or moved to auth_module
// import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthModuleRemoteDataSourceContract)
class AuthModuleRemoteDataSourceImpl
    implements AuthModuleRemoteDataSourceContract {
  final AuthModuleApiClient _apiClient;
  const AuthModuleRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<dynamic>> loginDriver(
    LoginParams params,
  ) async {
    return await executeApi(() async {
      return await _apiClient.loginDriver(params.email, params.password);
    });
  }
}
