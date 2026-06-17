import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetUserUseCase extends UseCase<UserEntity?, NoParams> {
  final LoginRepositoryContract _loginRepositoryContract;
  const GetUserUseCase(this._loginRepositoryContract);

  @override
  Future<Result<UserEntity?>> call(NoParams params) async {
    return await _loginRepositoryContract.getUser();
  }
}
