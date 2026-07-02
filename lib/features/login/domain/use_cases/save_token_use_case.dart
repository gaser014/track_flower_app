import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveTokenUseCase extends UseCase<void, String> {
  final LoginRepositoryContract _repository;

  SaveTokenUseCase(this._repository);

  @override
  Future<Result<void>> call(String params) async {
    return await _repository.saveToken(params);
  }
}
