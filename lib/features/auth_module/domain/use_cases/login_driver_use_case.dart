import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@injectable
class LoginDriverUseCase
    extends UseCase<DriverLoginResponseEntity, DriverLoginRequestEntity> {
  final AuthModuleRepository _repository;
  const LoginDriverUseCase(this._repository);

  @override
  Future<Result<DriverLoginResponseEntity>> call(
    DriverLoginRequestEntity params,
  ) async {
    return await _repository.loginDriver(params);
  }
}
