abstract class BaseEvent {}

class DisplayError extends BaseEvent {
  final String errorMsg;
  DisplayError(this.errorMsg);
}

class DisplaySuccess extends BaseEvent {
  final String successMsg;
  DisplaySuccess(this.successMsg);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;
  NavigateEvent(this.routeName, {this.extra});
}

class PopEvent extends BaseEvent {}

class PageChangeEvent extends BaseEvent {
  final int page;
  PageChangeEvent(this.page);
}

