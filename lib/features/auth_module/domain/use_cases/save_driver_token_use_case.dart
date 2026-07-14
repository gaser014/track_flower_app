import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@injectable
class SaveDriverTokenUseCase extends UseCase<void, String> {
  final AuthModuleRepository _repository;
  const SaveDriverTokenUseCase(this._repository);

  @override
  Future<Result<void>> call(String params) async {
    return await _repository.saveDriverToken(params);
  }
}
