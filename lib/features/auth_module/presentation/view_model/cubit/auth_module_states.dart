part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<dynamic> loginState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<dynamic> logoutState;
  final BaseState<Map<String, String?>> savedCredentials;

  const AuthModuleState({
    this.loginState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.logoutState = const BaseState.initial(),
    this.savedCredentials = const BaseState.initial(),
  });

  AuthModuleState copyWith({
    BaseState<dynamic>? loginState,
    BaseState<bool>? rememberMeState,
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
    );
  }

  @override
  List<Object?> get props => [
        loginState,
        rememberMeState,
        showPasswordState,
        logoutState,
        savedCredentials,
      ];
}
