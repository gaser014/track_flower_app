import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';

@Injectable(as: AuthModuleRemoteDataSourceContract)
class AuthModuleRemoteDataSourceImpl
    implements AuthModuleRemoteDataSourceContract {
  final AuthModuleApiClient _apiClient;

  const AuthModuleRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<void>> logoutDriver() async {
    return executeApi(() => _apiClient.logoutDriver());
  }
}
