import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/main_profile/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUseCase extends UseCase<ProfileResponseEntity?, Map<String, dynamic>> {
  final ProfileRepository _profileRepository;

  const EditProfileUseCase(this._profileRepository);

  @override
  Future<Result<ProfileResponseEntity?>> call(Map<String, dynamic> params) async {
    return await _profileRepository.editProfile(params);
  }
}
