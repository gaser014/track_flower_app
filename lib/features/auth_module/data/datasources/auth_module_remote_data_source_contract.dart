import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';


abstract interface class AuthModuleRemoteDataSourceContract {
  Future<Result<dynamic>> loginDriver(LoginParams params);
}
