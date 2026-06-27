import 'dart:io';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/login_response_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateProfilePhotoUseCase extends UseCase<LoginResponseEntity, File> {
  final LoginRepositoryContract _loginRepositoryContract;
  const UpdateProfilePhotoUseCase(this._loginRepositoryContract);
  @override
  Future<Result<LoginResponseEntity>> call(File params) async {
    return await _loginRepositoryContract.updateProfilePhoto(params);
  }
}
