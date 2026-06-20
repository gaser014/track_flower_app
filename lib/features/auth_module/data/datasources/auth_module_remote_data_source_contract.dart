import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';

abstract interface class AuthModuleRemoteDataSourceContract {
  Future<Result<DriverLoginResponseModel>> loginDriver(DriverLoginRequestEntity params);
}
