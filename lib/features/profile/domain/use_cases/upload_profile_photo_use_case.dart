import 'dart:io';

import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UploadProfilePhotoUseCase extends UseCase<String, File> {
  final ProfileRepositoryContract _repository;

  UploadProfilePhotoUseCase(this._repository);

  @override
  Future<Result<String>> call(File params) {
    return _repository.uploadProfilePhoto(params);
  }
}
