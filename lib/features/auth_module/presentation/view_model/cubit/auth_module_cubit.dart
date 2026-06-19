import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends Cubit<AuthModuleState> {
  final AuthModuleRepository _repository;

  AuthModuleCubit(this._repository) : super(const AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {
      case LogoutEvent():
        _logout();
      case RememberMeEvent():
        _setRememberMe(event.rememberMe);
      case ShowPasswordEvent():
        _setShowPassword(event.showPassword);
    }
  }

  // ── Load saved credentials on page open ───────────────────────────────────

  Future<void> loadSavedCredentials() async {
    final result = await _repository.getSavedCredentials();
    result.when(
      success: (credentials) {
        if (credentials != null &&
            credentials[AppStrings.driverSavedEmail] != null &&
            credentials[AppStrings.driverSavedPassword] != null) {
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



  Future<void> _logout() async {
    emit(state.copyWith(logoutState: const BaseState.loading()));

    // Call remote logout endpoint
    final remoteResult = await _repository.logoutDriver();

    // Always clear local token regardless of remote result
    await _repository.deleteDriverToken();

    remoteResult.when(
      success: (_) {
        emit(state.copyWith(logoutState: const BaseState.success(null)));
      },
      error: (_) {
        // Token already cleared locally — treat as soft success
        emit(state.copyWith(logoutState: const BaseState.success(null)));
      },
    );
  }

  // ── UI state helpers ──────────────────────────────────────────────────────

  void _setRememberMe(bool rememberMe) {
    emit(state.copyWith(rememberMeState: BaseState.success(rememberMe)));
  }

  void _setShowPassword(bool showPassword) {
    emit(state.copyWith(showPasswordState: BaseState.success(showPassword)));
  }
}
