import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class EditProfileUseCase
    extends UseCase<UserEntity, EditProfileRequestModel> {
  final ProfileRepositoryContract _repository;

  EditProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(EditProfileRequestModel params) {
    return _repository.editProfile(params);
  }
}
