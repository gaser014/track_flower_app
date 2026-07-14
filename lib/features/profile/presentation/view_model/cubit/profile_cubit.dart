import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/save_user_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/upload_profile_photo_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:injectable/injectable.dart';

part 'profile_states.dart';

@Injectable()
class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit(
    this._getProfileUseCase,
    this._saveUserUseCase,
    this._editProfileUseCase,
    this._uploadProfilePhotoUseCase,
    this._logoutUseCase,
    this._changePasswordUseCase,
  ) : super(const ProfileStates());

  final GetProfileUseCase _getProfileUseCase;
  final SaveUserUseCase _saveUserUseCase;
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfilePhotoUseCase _uploadProfilePhotoUseCase;
  final LogoutUseCase _logoutUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  void doIndented(ProfileEvents event) {
    switch (event) {
      case GetProfileEvent():
        _fetchProfile();
      case EditProfileEvent():
        _editProfile(event);
      case UploadProfilePhotoEvent():
        _uploadPhoto(event);
      case ToggleGenderEvent():
        emit(state.copyWith(selectedGender: event.gender));
      case TogglePasswordVisibilityEvent():
        emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
      case LogoutEvent():
        _logout();
      case ChangePasswordEvent():
        _changePassword(event);
    }
  }

  Future<void> _fetchProfile() async {
    emit(state.copyWith(profileState: const BaseState.loading()));

    final remoteResult = await _getProfileUseCase.call(const NoParams());
    remoteResult.when(
      success: (user) async {
        if (user != null) {
          await _saveUserUseCase.call(user);
          emit(
            state.copyWith(
              profileState: BaseState.success(user),
              selectedGender: user.gender ?? 'Male',
            ),
          );
        }
      },
      error: (exception) {
        emit(state.copyWith(profileState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _editProfile(EditProfileEvent event) async {
    emit(state.copyWith(editProfileState: const BaseState.loading()));

    final remoteResult = await _editProfileUseCase.call(event.request);
    remoteResult.when(
      success: (user) async {
        if (user != null) {
          await _saveUserUseCase.call(user);
          emit(
            state.copyWith(
              editProfileState: BaseState.success(user),
              profileState: BaseState.success(user),
            ),
          );
        }
      },
      error: (exception) {
        emit(state.copyWith(editProfileState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _uploadPhoto(UploadProfilePhotoEvent event) async {
    emit(state.copyWith(uploadPhotoState: const BaseState.loading()));
    // Set local photo path immediately for instant UI feedback
    emit(state.copyWith(localPhotoPath: event.photo.path));

    final remoteResult = await _uploadProfilePhotoUseCase.call(event.photo);
    remoteResult.when(
      success: (photoUrl) async {
        if (photoUrl != null) {
          emit(state.copyWith(uploadPhotoState: BaseState.success(photoUrl)));
          // Refresh profile to get the new user data with the photo
          doIndented(GetProfileEvent());
        }
      },
      error: (exception) {
        emit(state.copyWith(uploadPhotoState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: const BaseState.loading()));

    final result = await _logoutUseCase.call(const NoParams());
    result.when(
      success: (_) {
        emit(state.copyWith(logoutState: const BaseState.success(null)));
      },
      error: (exception) {
        emit(state.copyWith(logoutState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _changePassword(ChangePasswordEvent event) async {
    emit(state.copyWith(changePasswordState: const BaseState.loading()));

    final result = await _changePasswordUseCase.call(event.request);
    result.when(
      success: (_) {
        emit(state.copyWith(changePasswordState: const BaseState.success(null)));
      },
      error: (exception) {
        emit(state.copyWith(changePasswordState: BaseState.error(exception)));
      },
    );
  }
}
