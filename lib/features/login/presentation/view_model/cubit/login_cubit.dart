import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/save_user_use_case.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_states.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginUseCase, this.saveUserUseCase)
    : super(const LoginStates());

  final LoginUseCase loginUseCase;
  final SaveUserUseCase saveUserUseCase;

  void doIndented(LoginEvents event) {
    switch (event) {
      case LoginEvent():
        _login(event.params);
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
      case ShowPasswordEvent():
        _showPassword(event.showPassword);
    }
  }

  Future<void> _login(LoginParams params) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final result = await loginUseCase.call(params);
    result.when(
      success: (response) async {
        if (response != null) {
          if (response.user != null) {
            await saveUserUseCase.call(response.user!);
          }
          if (params.remember == true && response.token != null) {
            await AppSharedPreferences.setString(
              key: AppStrings.token,
              value: response.token!,
            );
          }
        }
        emit(state.copyWith(loginState: BaseState.success(response)));
      },
      error: (Exception? exception) {
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
}
