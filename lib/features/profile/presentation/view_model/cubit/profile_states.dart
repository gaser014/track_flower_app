part of 'profile_cubit.dart';

class ProfileStates extends Equatable {
  final BaseState<UserEntity> profileState;
  final BaseState<UserEntity> editProfileState;
  final BaseState<String> uploadPhotoState;
  final BaseState<void> logoutState;
  final BaseState<void> changePasswordState;
  final String selectedGender;
  final bool isPasswordVisible;
  final String? localPhotoPath;

  const ProfileStates({
    this.profileState = const BaseState.initial(),
    this.editProfileState = const BaseState.initial(),
    this.uploadPhotoState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
    this.changePasswordState = const BaseState.initial(),
    this.selectedGender = 'Male',
    this.isPasswordVisible = false,
    this.localPhotoPath,
  });

  ProfileStates copyWith({
    BaseState<UserEntity>? profileState,
    BaseState<UserEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
    BaseState<void>? logoutState,
    BaseState<void>? changePasswordState,
    String? selectedGender,
    bool? isPasswordVisible,
    String? localPhotoPath,
  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
      editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
      logoutState: logoutState ?? this.logoutState,
      changePasswordState: changePasswordState ?? this.changePasswordState,
      selectedGender: selectedGender ?? this.selectedGender,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
    );
  }

  @override
  List<Object?> get props => [
        profileState,
        editProfileState,
        uploadPhotoState,
        logoutState,
        changePasswordState,
        selectedGender,
        isPasswordVisible,
        localPhotoPath,
      ];
}
