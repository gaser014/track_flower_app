import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@injectable
class SendForgetPasswordCodeUseCase
    extends UseCase<void, ForgetPasswordParams> {
  final AuthModuleRepository _repository;

  const SendForgetPasswordCodeUseCase(this._repository);

  @override
  Future<Result<void>> call(ForgetPasswordParams params) =>
      _repository.sendForgetPasswordCode(params);
}

@injectable
class VerifyForgetPasswordCodeUseCase
    extends UseCase<void, ForgetPasswordParams> {
  final AuthModuleRepository _repository;

  const VerifyForgetPasswordCodeUseCase(this._repository);

  @override
  Future<Result<void>> call(ForgetPasswordParams params) =>
      _repository.verifyForgetPasswordCode(params);
}

@injectable
class ResetPasswordUseCase extends UseCase<void, ForgetPasswordParams> {
  final AuthModuleRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Result<void>> call(ForgetPasswordParams params) =>
      _repository.resetPassword(params);
}
