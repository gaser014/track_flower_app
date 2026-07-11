import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMainProfileUseCase extends UseCase<UserEntity?, NoParams> {
  final LoginRepositoryContract _loginRepository;

  const GetMainProfileUseCase(this._loginRepository);

  @override
  Future<Result<UserEntity?>> call(NoParams params) async {
    final result = await _loginRepository.getProfile();
    return result.when(
      success: (response) => Success(data: response?.user),
      error: (exception) => Error(exception: exception),
    );
  }
}
