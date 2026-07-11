import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetProfileUseCase extends UseCase<UserEntity, NoParams> {
  final ProfileRepositoryContract _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) {
    return _repository.getProfileData();
  }
}
