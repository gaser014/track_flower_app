import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';

abstract class StateHandler<T> {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Exception exception) error,
  });
}

abstract class PaginationStateHandler<T> {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(List<T> data) loadingMore,
    required R Function(List<T> data, MetaEntity? meta) success,
    required R Function(Exception exception) error,
    required R Function(List<T> data, Exception exception) errorMore,
  });
}
