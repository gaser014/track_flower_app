
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends Cubit<AuthModuleState> {
  final AuthModuleRepository _repository;

  AuthModuleCubit(this._repository) : super(const AuthModuleState());

 
  void doIndented(AuthModuleEvent event) {
    switch (event) {
      // Login Events
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

  
  Future<void> loadSavedCredentials() async {
    final result = await _repository.getSavedCredentials();
    result.when(
      success: (credentials) {
        if (credentials != null &&
            credentials['driverSavedEmail'] != null &&
            credentials['driverSavedPassword'] != null) {
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

  Future<void> _login(LoginParams params) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final result = await _repository.loginDriver(params);
    result.when(
      success: (response) async {
        if (response?.token != null) {
          await _repository.saveDriverToken(response!.token!);
        }
        if (params.remember ?? false) {
          await _repository.saveCredentials(
            email: params.email,
            password: params.password,
          );
        } else {
          await _repository.deleteCredentials();
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
    final result = await _repository.deleteDriverToken();
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
  //   final result = await _repository.signUp(params);
  //   ...
  // }
}
