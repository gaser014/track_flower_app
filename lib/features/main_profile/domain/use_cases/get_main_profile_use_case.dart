import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/main_profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetMainProfileUseCase extends UseCase<UserEntity, NoParams> {
  final MainProfileRepositoryContract _repository;

  GetMainProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) {
    return _repository.getProfileData();
  }
}
