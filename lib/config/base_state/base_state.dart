import 'package:equatable/equatable.dart';

import 'state_handlers.dart';
import 'state_types.dart';

class BaseState<T> extends Equatable implements StateHandler<T> {
  final BaseStateType state;
  final T? data;
  final Exception? exception;

  const BaseState({
    this.state = BaseStateType.initial,
    this.data,
    this.exception,
  });

  @override
  List<Object?> get props => [state, data, exception];

  const BaseState.initial()
    : state = BaseStateType.initial,
      data = null,
      exception = null;

  const BaseState.loading()
    : state = BaseStateType.loading,
      data = null,
      exception = null;

  const BaseState.success(this.data)
    : state = BaseStateType.success,
      exception = null;

  const BaseState.error(this.exception)
    : state = BaseStateType.error,
      data = null;

  bool get isInitial => state == BaseStateType.initial;

  bool get isLoading => state == BaseStateType.loading;

  bool get isSuccess => state == BaseStateType.success;

  bool get isError => state == BaseStateType.error;

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Exception exception) error,
  }) {
    return switch (state) {
      BaseStateType.initial => initial(),
      BaseStateType.loading => loading(),
      BaseStateType.success => success(data as T),
      BaseStateType.error => error(exception!),
    };
  }

  @override
  String toString() =>
      'BaseState($state${data != null ? ', data: $data' : ''}${exception != null ? ', error: $exception' : ''})';
}
