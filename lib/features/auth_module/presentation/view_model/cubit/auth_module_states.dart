part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<void> sendCodeState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;
  final BaseState<dynamic> loginState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<dynamic> logoutState;
  final BaseState<SavedCredentialsResponseEntity> savedCredentials;

  const AuthModuleState({
    this.sendCodeState = const BaseState.initial(),
    this.verifyCodeState = const BaseState.initial(),
    this.resetPasswordState = const BaseState.initial(),
    this.loginState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.logoutState = const BaseState.initial(),
    this.savedCredentials = const BaseState.initial(),
  });

  AuthModuleState copyWith({
    BaseState<void>? sendCodeState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
    BaseState<dynamic>? loginState,
    BaseState<bool>? rememberMeState,
    BaseState<bool>? showPasswordState,
    BaseState<dynamic>? logoutState,
    BaseState<SavedCredentialsResponseEntity>? savedCredentials,
  }) {
    return AuthModuleState(
      sendCodeState: sendCodeState ?? this.sendCodeState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      loginState: loginState ?? this.loginState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      logoutState: logoutState ?? this.logoutState,
      savedCredentials: savedCredentials ?? this.savedCredentials,
    );
  }

  @override
  List<Object?> get props => [
        sendCodeState,
        verifyCodeState,
        resetPasswordState,
        loginState,
        rememberMeState,
        showPasswordState,
        logoutState,
        savedCredentials,
      ];
}
