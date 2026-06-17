import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginUseCase extends UseCase<LoginResponseEntity, LoginParams> {
  final LoginRepositoryContract _loginRepositoryContract;
  const LoginUseCase(this._loginRepositoryContract);
  @override
  Future<Result<LoginResponseEntity>> call(LoginParams params) async {
    return await _loginRepositoryContract.login(params);
  }
}
