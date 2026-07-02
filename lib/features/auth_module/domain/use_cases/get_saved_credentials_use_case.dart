import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/saved_credentials_response_entity.dart';

@injectable
class GetSavedCredentialsUseCase
    extends UseCase<SavedCredentialsResponseEntity, NoParams> {
  final AuthModuleRepository _repository;
  const GetSavedCredentialsUseCase(this._repository);

  @override
  Future<Result<SavedCredentialsResponseEntity>> call(NoParams params) async {
    return await _repository.getSavedCredentials();
  }
}
