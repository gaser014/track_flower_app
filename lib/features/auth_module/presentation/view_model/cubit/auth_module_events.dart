

sealed class AuthModuleEvent {}



class LogoutEvent extends AuthModuleEvent {}

class RememberMeEvent extends AuthModuleEvent {
  final bool rememberMe;
  RememberMeEvent({required this.rememberMe});
}

class ShowPasswordEvent extends AuthModuleEvent {
  final bool showPassword;
  ShowPasswordEvent({required this.showPassword});
}
