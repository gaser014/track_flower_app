import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

class SaveDriverCredentialsParams {
  final String email;
  final String password;
  const SaveDriverCredentialsParams({
    required this.email,
    required this.password,
  });
}

@injectable
class SaveDriverCredentialsUseCase
    extends UseCase<void, SaveDriverCredentialsParams> {
  final AuthModuleRepository _repository;
  const SaveDriverCredentialsUseCase(this._repository);

  @override
  Future<Result<void>> call(SaveDriverCredentialsParams params) async {
    return await _repository.saveCredentials(
      email: params.email,
      password: params.password,
    );
  }
}
