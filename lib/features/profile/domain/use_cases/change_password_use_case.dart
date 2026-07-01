import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ChangePasswordUseCase extends UseCase<void, ChangePasswordRequestModel> {
  final ProfileRepositoryContract _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Result<void>> call(ChangePasswordRequestModel params) {
    return _repository.changePassword(params);
  }
}
