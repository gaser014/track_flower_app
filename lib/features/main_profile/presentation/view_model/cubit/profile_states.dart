import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';

class ProfileStates extends Equatable {
  final BaseState getProfileState;
  final BaseState editProfileState;
  final BaseState updateProfilePhotoState;
  final BaseState resetPasswordState;

  const ProfileStates({
    this.getProfileState = const BaseState.initial(),
    this.editProfileState = const BaseState.initial(),
    this.updateProfilePhotoState = const BaseState.initial(),
    this.resetPasswordState = const BaseState.initial(),
  });

  ProfileStates copyWith({
    BaseState? getProfileState,
    BaseState? editProfileState,
    BaseState? updateProfilePhotoState,
    BaseState? resetPasswordState,
  }) {
    return ProfileStates(
      getProfileState: getProfileState ?? this.getProfileState,
      editProfileState: editProfileState ?? this.editProfileState,
      updateProfilePhotoState: updateProfilePhotoState ?? this.updateProfilePhotoState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [
        getProfileState,
        editProfileState,
        updateProfilePhotoState,
        resetPasswordState,
      ];
}
