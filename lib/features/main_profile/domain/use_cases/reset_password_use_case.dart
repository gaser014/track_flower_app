import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/main_profile/domain/entities/reset_password_response_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordUseCase extends UseCase<ResetPasswordResponseEntity, Map<String, dynamic>> {
  final ProfileRepository _profileRepository;

  const ResetPasswordUseCase(this._profileRepository);

  @override
  Future<Result<ResetPasswordResponseEntity>> call(Map<String, dynamic> params) async {
    return await _profileRepository.resetPassword(params);
  }
}
