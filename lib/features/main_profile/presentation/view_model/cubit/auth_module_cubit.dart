import 'dart:io';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/main_profile/data/static/static_profile_data.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/get_profile_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/update_profile_photo_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/reset_password_use_case.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/auth_module_events.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/auth_module_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthModuleCubit extends Cubit<AuthModuleStates> {
  final GetProfileUseCase _getProfileUseCase;
  final EditProfileUseCase _editProfileUseCase;
  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthModuleCubit(
    this._getProfileUseCase,
    this._editProfileUseCase,
    this._updateProfilePhotoUseCase,
    this._resetPasswordUseCase,
  ) : super(const AuthModuleStates());

  void doIndented(AuthModuleEvents event) {
    switch (event) {
      case GetProfileEvent():
        _getProfile();
      case EditProfileEvent():
        _editProfile(event.body);
      case UpdateProfilePhotoEvent():
        _updateProfilePhoto(event.file);
      case ResetPasswordEvent():
        _resetPassword(event.body);
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(getProfileState: BaseState.loading()));
    await Future.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(
      getProfileState: BaseState.success(StaticProfileData.profile),
    ));
    return;
    // ignore: dead_code
    emit(state.copyWith(getProfileState: BaseState.loading()));
    final result = await _getProfileUseCase(NoParams());
    result.when(
      success: (response) {
        if (response?.profile != null) {
          emit(state.copyWith(
            getProfileState: BaseState.success(response!.profile!),
          ));
        } else {
          emit(state.copyWith(
            getProfileState: BaseState.error(Exception('Profile data is null')),
          ));
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
        if (response?.profile != null) {
          emit(state.copyWith(
            editProfileState: BaseState.success(response!.profile!),
          ));
        } else {
          emit(state.copyWith(
            editProfileState:
                BaseState.error(Exception('Failed to update profile')),
          ));
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
        if (response?.profile != null) {
          emit(state.copyWith(
            updateProfilePhotoState: BaseState.success(response!.profile!),
          ));
        } else {
          emit(state.copyWith(
            updateProfilePhotoState:
                BaseState.error(Exception('Failed to update photo')),
          ));
        }
      },
      error: (error) {
        emit(state.copyWith(updateProfilePhotoState: BaseState.error(error)));
      },
    );
  }

  Future<void> _resetPassword(Map<String, dynamic> body) async {
    emit(state.copyWith(resetPasswordState: BaseState.loading()));
    final result = await _resetPasswordUseCase(body);
    result.when(
      success: (response) {
        emit(state.copyWith(
          resetPasswordState: BaseState.success(response ?? Object()),
        ));
      },
      error: (error) {
        emit(state.copyWith(resetPasswordState: BaseState.error(error)));
      },
    );
  }
}
