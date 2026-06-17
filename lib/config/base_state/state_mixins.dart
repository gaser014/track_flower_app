import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';

import 'pagination_state.dart';

mixin StateTransitions<T> {
  BaseState<T> toLoading() => const BaseState.loading();

  BaseState<T> toSuccess(T data) => BaseState.success(data);

  BaseState<T> toError(Exception e) => BaseState.error(e);

  BaseState<T> toInitial() => const BaseState.initial();
}

mixin PaginationTransitions<T> {
  PaginationState<T> toLoading({PaginationParams? query});

  PaginationState<T> toLoadingMore();

  PaginationState<T> toSuccess(List<T> data, {MetaEntity? meta});

  PaginationState<T> toError(Exception e);

  PaginationState<T> toErrorMore(Exception e);

  PaginationState<T> toInitial() => const PaginationState.initial();
}
