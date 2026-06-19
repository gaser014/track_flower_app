part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<DriverLoginResponseEntity> loginState;
  final BaseState<void> logoutState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<Map<String, String?>> savedCredentials;

  const AuthModuleState({
    this.loginState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.savedCredentials = const BaseState.initial(),
  });

  AuthModuleState copyWith({
    BaseState<DriverLoginResponseEntity>? loginState,
    BaseState<void>? logoutState,
    BaseState<bool>? rememberMeState,
    BaseState<bool>? showPasswordState,
    BaseState<Map<String, String?>>? savedCredentials,
  }) {
    return AuthModuleState(
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
    logoutState,
    rememberMeState,
    showPasswordState,
    savedCredentials,
  ];
}
