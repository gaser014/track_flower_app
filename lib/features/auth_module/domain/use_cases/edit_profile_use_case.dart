import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/profile_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class EditProfileUseCase extends UseCase<ProfileResponseEntity, Map<String, dynamic>> {
  final AuthModuleRepository _repository;
  const EditProfileUseCase(this._repository);
  @override
  Future<Result<ProfileResponseEntity>> call(Map<String, dynamic> params) async {
    return await _repository.editProfile(params);
  }
}
