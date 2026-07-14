
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/config/base_state/base_event.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/saved_credentials_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/delete_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_saved_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/login_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/logout_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_token_use_case.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends BaseCubit<AuthModuleState, BaseEvent> {
  final SendForgetPasswordCodeUseCase _sendForgetPasswordCodeUseCase;
  final VerifyForgetPasswordCodeUseCase _verifyForgetPasswordCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  
  final LoginDriverUseCase _loginDriverUseCase;
  final LogoutDriverUseCase _logoutDriverUseCase;
  final GetSavedCredentialsUseCase _getSavedCredentialsUseCase;
  final SaveDriverTokenUseCase _saveDriverTokenUseCase;
  final SaveDriverCredentialsUseCase _saveDriverCredentialsUseCase;
  final DeleteDriverCredentialsUseCase _deleteDriverCredentialsUseCase;

  AuthModuleCubit(
    this._sendForgetPasswordCodeUseCase,
    this._verifyForgetPasswordCodeUseCase,
    this._resetPasswordUseCase,
    this._loginDriverUseCase,
    this._logoutDriverUseCase,
    this._getSavedCredentialsUseCase,
    this._saveDriverTokenUseCase,
    this._saveDriverCredentialsUseCase,
    this._deleteDriverCredentialsUseCase,
  ) : super(const AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {
      case SendCodeEvent():
        _sendCode(event.params);
      case VerifyCodeEvent():
        _verifyCode(event.params);
      case ResetPasswordEvent():
        _resetPassword(event.params);
      case LoginEvent():
        _login(event.params);
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
      case ShowPasswordEvent():
        _showPassword(event.showPassword);
      case LogoutEvent():
        _logout();
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

  Future<void> loadSavedCredentials() async {
    final result = await _getSavedCredentialsUseCase(const NoParams());
    result.when(
      success: (credentials) {
        if (credentials != null &&
            credentials.email != null &&
            credentials.password != null) {
          emit(
            state.copyWith(
              savedCredentials: BaseState.success(credentials),
              rememberMeState: const BaseState.success(true),
            ),
          );
        }
      },
      error: (_) {},
    );
  }

  Future<void> _login(DriverLoginRequestEntity params) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final result = await _loginDriverUseCase(params);
    result.when(
      success: (response) async {
        if (response?.token != null) {
          await _saveDriverTokenUseCase(response!.token);
        }
        if (params.remember ?? false) {
          await _saveDriverCredentialsUseCase(
            SaveCredentialsRequestEntity(
              email: params.email,
              password: params.password,
            ),
          );
        } else {
          await _deleteDriverCredentialsUseCase(const NoParams());
        }
        emit(state.copyWith(loginState: BaseState.success(response)));
      },
      error: (exception) {
        emit(state.copyWith(loginState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _rememberMe(bool rememberMe) async {
    emit(state.copyWith(rememberMeState: BaseState.success(rememberMe)));
  }

  Future<void> _showPassword(bool showPassword) async {
    emit(state.copyWith(showPasswordState: BaseState.success(showPassword)));
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    final result = await _logoutDriverUseCase(const NoParams());
    result.when(
      success: (_) {
        emit(state.copyWith(logoutState: BaseState.success(null)));
      },
      error: (exception) {
        emit(state.copyWith(logoutState: BaseState.error(exception)));
      },
    );
  }

  // ===========================================================================
  // [3] Sign Up Feature Methods (For the Team to Implement)
  // ===========================================================================
  // TODO (Team): Add _signUp logic here
  // Future<void> _signUp(SignUpParams params) async {
  //   emit(state.copyWith(signUpState: BaseState.loading()));
  //   final result = await _signUpUseCase(params);
  //   ...
  // }
}

