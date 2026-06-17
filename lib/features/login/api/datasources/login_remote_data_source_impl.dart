import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/login/api/api_client/login_api_client.dart';
import 'package:track_flowers_app/features/login/data/datasources/login_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/login/data/models/login_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRemoteDataSourceContract)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSourceContract {
  final LoginApiClient _apiClient;
  const LoginRemoteDataSourceImpl(this._apiClient);
  @override
  Future<Result<LoginResponseModel>> login(LoginParams params) async {
    return await executeApi(() async {
      final response = await _apiClient.login(params.email, params.password);
      return response;
    });
  }
}
