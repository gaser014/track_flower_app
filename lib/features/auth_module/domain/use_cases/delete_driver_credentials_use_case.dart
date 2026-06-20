import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@injectable
class DeleteDriverCredentialsUseCase extends UseCase<void, NoParams> {
  final AuthModuleRepository _repository;
  const DeleteDriverCredentialsUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await _repository.deleteCredentials();
  }
}
