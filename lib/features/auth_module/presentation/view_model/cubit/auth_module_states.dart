part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<void> sendCodeState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;

  const AuthModuleState({
    this.sendCodeState = const BaseState.initial(),
    this.verifyCodeState = const BaseState.initial(),
    this.resetPasswordState = const BaseState.initial(),
  });

  AuthModuleState copyWith({
    BaseState<void>? sendCodeState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
  }) {
    return AuthModuleState(
      sendCodeState: sendCodeState ?? this.sendCodeState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [
        sendCodeState,
        verifyCodeState,
        resetPasswordState,
      ];
}
