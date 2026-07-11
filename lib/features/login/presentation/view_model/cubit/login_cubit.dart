import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/config/api/api_key.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/get_profile_use_case.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/edit_profile_use_case.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/update_profile_photo_use_case.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/save_user_use_case.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_states.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(
    this.loginUseCase,
    this.saveUserUseCase,
    this._getProfileUseCase,
    this._editProfileUseCase,
    this._updateProfilePhotoUseCase,
  ) : super(const LoginStates());

  final LoginUseCase loginUseCase;
  final SaveUserUseCase saveUserUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final EditProfileUseCase _editProfileUseCase;
  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;

  void doIndented(LoginEvents event) {
    switch (event) {
      case LoginEvent():
        _login(event.params);
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
      case ShowPasswordEvent():
        _showPassword(event.showPassword);
      case GetProfileEvent():
        _getProfile();
      case EditProfileEvent():
        _editProfile(event.body);
      case UpdateProfilePhotoEvent():
        _updateProfilePhoto(event.file);
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
          await AppSharedPreferences.setBool(
            key: APIkeys.rememberMe,
            value: params.remember ?? false,
          );
          if (response.token != null) {
            await AppSharedPreferences.setString(
              key: APIkeys.accessToken,
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

  Future<void> _getProfile() async {
    emit(state.copyWith(getProfileState: BaseState.loading()));
    final result = await _getProfileUseCase(NoParams());
    result.when(
      success: (response) {
        if (response?.user != null) {
          emit(
            state.copyWith(getProfileState: BaseState.success(response!.user!)),
          );
        } else {
          emit(
            state.copyWith(
              getProfileState: BaseState.error(
                Exception("User profile data is null"),
              ),
            ),
          );
        }
      },
      error: (error) {
        emit(state.copyWith(getProfileState: BaseState.error(error)));
      },
    );
  }

  Future<void> _editProfile(Map<String, dynamic> body) async {
    emit(state.copyWith(editProfileState: BaseState.loading()));
    final result = await _editProfileUseCase(body);
    result.when(
      success: (response) {
        if (response?.user != null) {
          emit(
            state.copyWith(
              editProfileState: BaseState.success(response!.user!),
            ),
          );
        } else {
          emit(
            state.copyWith(
              editProfileState: BaseState.error(
                Exception("Failed to update profile"),
              ),
            ),
          );
        }
      },
      error: (error) {
        emit(state.copyWith(editProfileState: BaseState.error(error)));
      },
    );
  }

  Future<void> _updateProfilePhoto(File file) async {
    emit(state.copyWith(updateProfilePhotoState: BaseState.loading()));
    final result = await _updateProfilePhotoUseCase(file);
    result.when(
      success: (response) {
        if (response?.user != null) {
          emit(
            state.copyWith(
              updateProfilePhotoState: BaseState.success(response!.user!),
            ),
          );
        } else {
          emit(
            state.copyWith(
              updateProfilePhotoState: BaseState.error(
                Exception("Failed to update profile photo"),
              ),
            ),
          );
        }
      },
      error: (error) {
        emit(state.copyWith(updateProfilePhotoState: BaseState.error(error)));
      },
    );
  }
}
