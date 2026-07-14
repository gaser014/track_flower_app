import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';

// Removed custom params class

@injectable
class SaveDriverCredentialsUseCase
    extends UseCase<void, SaveCredentialsRequestEntity> {
  final AuthModuleRepository _repository;
  const SaveDriverCredentialsUseCase(this._repository);

  @override
  Future<Result<void>> call(SaveCredentialsRequestEntity params) async {
    return await _repository.saveCredentials(params);
  }
}
