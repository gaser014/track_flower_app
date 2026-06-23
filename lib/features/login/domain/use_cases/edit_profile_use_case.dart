import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class EditProfileUseCase extends UseCase<LoginResponseEntity, Map<String, dynamic>> {
  final LoginRepositoryContract _loginRepositoryContract;
  const EditProfileUseCase(this._loginRepositoryContract);
  @override
  Future<Result<LoginResponseEntity>> call(Map<String, dynamic> params) async {
    return await _loginRepositoryContract.editProfile(params);
  }
}
