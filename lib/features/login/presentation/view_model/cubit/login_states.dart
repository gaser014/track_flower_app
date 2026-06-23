part of 'login_cubit.dart';

class LoginStates extends Equatable {
  final BaseState loginState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState getProfileState;
  final BaseState editProfileState;
  final BaseState updateProfilePhotoState;

  const LoginStates({
    this.loginState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.getProfileState = const BaseState.initial(),
    this.editProfileState = const BaseState.initial(),
    this.updateProfilePhotoState = const BaseState.initial(),
  });

  LoginStates copyWith({
    BaseState? loginState,
    BaseState<bool>? rememberMeState,
    BaseState<bool>? showPasswordState,
    BaseState? getProfileState,
    BaseState? editProfileState,
    BaseState? updateProfilePhotoState,
  }) {
    return LoginStates(
      loginState: loginState ?? this.loginState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      getProfileState: getProfileState ?? this.getProfileState,
      editProfileState: editProfileState ?? this.editProfileState,
      updateProfilePhotoState: updateProfilePhotoState ?? this.updateProfilePhotoState,
    );
  }

  @override
  List<Object?> get props => [
        loginState,
        rememberMeState,
        showPasswordState,
        getProfileState,
        editProfileState,
        updateProfilePhotoState,
      ];
}
