import 'package:track_flowers_app/config/base_response/result.dart';

abstract interface class AuthModuleRemoteDataSourceContract {
  Future<Result<void>> logoutDriver();
}
