import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/main_profile/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateProfilePhotoUseCase extends UseCase<ProfileResponseEntity, File> {
  final ProfileRepository _repository;
  const UpdateProfilePhotoUseCase(this._repository);
  @override
  Future<Result<ProfileResponseEntity>> call(File params) async {
    return await _repository.updateProfilePhoto(params);
  }
}
