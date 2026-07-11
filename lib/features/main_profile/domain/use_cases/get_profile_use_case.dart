import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/main_profile/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileUseCase extends UseCase<ProfileResponseEntity?, NoParams> {
  final ProfileRepository _profileRepository;

  const GetProfileUseCase(this._profileRepository);

  @override
  Future<Result<ProfileResponseEntity?>> call(NoParams params) async {
    return await _profileRepository.getProfile();
  }
}
