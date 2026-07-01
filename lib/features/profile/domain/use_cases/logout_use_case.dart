import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LogoutUseCase extends UseCase<void, NoParams> {
  final ProfileRepositoryContract _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}
