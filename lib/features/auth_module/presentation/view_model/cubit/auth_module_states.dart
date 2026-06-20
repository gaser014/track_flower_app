part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<dynamic> loginState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<dynamic> logoutState;
  final BaseState<Map<String, String?>> savedCredentials;
  final BaseState<void> sendCodeState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;
  final BaseState<DriverLoginResponseEntity> loginState;
  final BaseState<void> logoutState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<Map<String, String?>> savedCredentials;

  const AuthModuleState({
    this.loginState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.logoutState = const BaseState.initial(),
    this.savedCredentials = const BaseState.initial(),
    this.sendCodeState = const BaseState.initial(),
    this.verifyCodeState = const BaseState.initial(),
    this.resetPasswordState = const BaseState.initial(),
    this.loginState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.savedCredentials = const BaseState.initial(),

  });

  AuthModuleState copyWith({
    BaseState<dynamic>? loginState,
    BaseState<bool>? rememberMeState,
    BaseState<void>? sendCodeState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
    BaseState<DriverLoginResponseEntity>? loginState,
    BaseState<void>? logoutState,
    BaseState<bool>? rememberMeState,
    BaseState<bool>? showPasswordState,
    BaseState<Map<String, String?>>? savedCredentials,

    BaseState<bool>? showPasswordState,
    BaseState<dynamic>? logoutState,
    BaseState<Map<String, String?>>? savedCredentials,
  }) {
    return AuthModuleState(
      loginState: loginState ?? this.loginState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      logoutState: logoutState ?? this.logoutState,
      savedCredentials: savedCredentials ?? this.savedCredentials,
      sendCodeState: sendCodeState ?? this.sendCodeState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      loginState: loginState ?? this.loginState,
      logoutState: logoutState ?? this.logoutState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      savedCredentials: savedCredentials ?? this.savedCredentials,

    );
  }

  @override
  List<Object?> get props => [
        loginState,
        rememberMeState,
        showPasswordState,
        logoutState,
        savedCredentials,
    sendCodeState,    loginState,
    logoutState,
    rememberMeState,
    showPasswordState,
    savedCredentials,

    verifyCodeState,
    resetPasswordState,

  ];
}
