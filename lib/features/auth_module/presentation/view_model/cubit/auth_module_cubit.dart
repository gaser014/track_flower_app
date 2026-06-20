import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/config/base_state/base_event.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends BaseCubit<AuthModuleState, BaseEvent> {
  final SendForgetPasswordCodeUseCase _sendForgetPasswordCodeUseCase;
  final VerifyForgetPasswordCodeUseCase _verifyForgetPasswordCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthModuleCubit(
    this._sendForgetPasswordCodeUseCase,
    this._verifyForgetPasswordCodeUseCase,
    this._resetPasswordUseCase,
  ) : super(const AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {
      case SendCodeEvent():
        _sendCode(event.params);
      case VerifyCodeEvent():
        _verifyCode(event.params);
      case ResetPasswordEvent():
        _resetPassword(event.params);
    }
  }

  Future<void> _sendCode(ForgetPasswordParams params) async {
    emit(state.copyWith(sendCodeState: const BaseState.loading()));
    final result = await _sendForgetPasswordCodeUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(sendCodeState: const BaseState.success(null)));
        emitEvent(PageChangeEvent(1));
      },
      error: (exception) {
        emit(state.copyWith(sendCodeState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }

  Future<void> _verifyCode(ForgetPasswordParams params) async {
    emit(state.copyWith(verifyCodeState: const BaseState.loading()));
    final result = await _verifyForgetPasswordCodeUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(verifyCodeState: const BaseState.success(null)));
        emitEvent(PageChangeEvent(2));
      },
      error: (exception) {
        emit(state.copyWith(verifyCodeState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }

  Future<void> _resetPassword(ForgetPasswordParams params) async {
    emit(state.copyWith(resetPasswordState: const BaseState.loading()));
    final result = await _resetPasswordUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(resetPasswordState: const BaseState.success(null)));
        emitEvent(DisplaySuccess(AppStrings.passwordResetSuccess));
        emitEvent(PopEvent());
      },
      error: (exception) {
        emit(state.copyWith(resetPasswordState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }
}

