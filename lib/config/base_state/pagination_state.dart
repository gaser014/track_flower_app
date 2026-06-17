import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';

import 'state_handlers.dart';
import 'state_mixins.dart';
import 'state_types.dart';

class PaginationState<T> extends Equatable
    with PaginationTransitions<T>
    implements PaginationStateHandler<T> {
  final PaginationStateType state;
  final List<T> data;
  final MetaEntity? meta;
  final Exception? exception;
  final PaginationParams query;

  const PaginationState({
    required this.state,
    required this.data,
    this.meta,
    this.exception,
    required this.query,
  });

  @override
  List<Object?> get props => [state, data, meta, exception, query];

  const PaginationState.initial()
    : state = PaginationStateType.initial,
      data = const [],
      meta = null,
      exception = null,
      query = const PaginationParams();

  bool get isInitial => state == PaginationStateType.initial;

  bool get isLoading => state == PaginationStateType.loading;

  bool get isLoadingMore => state == PaginationStateType.loadingMore;

  bool get isSuccess => state == PaginationStateType.success;

  bool get isError => state == PaginationStateType.error;

  bool get isErrorMore => state == PaginationStateType.errorMore;

  bool get isEmpty => data.isEmpty;

  bool get isNotEmpty => data.isNotEmpty;

  int get itemCount => data.length;

  bool get hasMore => meta?.hasNextPage ?? true;

  bool get canLoadMore => hasMore && isNotEmpty && !isLoadingMore;

  int get currentPage => meta?.currentPage ?? query.page ?? 1;

  int get totalPages => meta?.numberOfPages ?? 1;

  int get totalItems => meta?.totalItems ?? 0;

  @override
  PaginationState<T> toLoading({PaginationParams? query}) => PaginationState(
    state: PaginationStateType.loading,
    data: const [],
    meta: null,
    query: query ?? this.query.copyWith(page: 1),
  );

  @override
  PaginationState<T> toLoadingMore() => PaginationState(
    state: PaginationStateType.loadingMore,
    data: data,
    meta: meta,
    query: query.copyWith(page: currentPage + 1),
  );

  @override
  PaginationState<T> toSuccess(List<T> newData, {MetaEntity? meta}) {
    final currentPage = query.page ?? 1;
    return PaginationState(
      state: PaginationStateType.success,
      data: currentPage == 1 ? newData : [...data, ...newData],
      meta: meta ?? this.meta,
      query: query,
    );
  }

  PaginationState<T> toSuccessFromEntity(BasePaginationEntity<T> entity) {
    final currentPage = query.page ?? 1;
    return PaginationState(
      state: PaginationStateType.success,
      data: currentPage == 1 ? entity.data : [...data, ...entity.data],
      meta: entity.meta,
      query: query,
    );
  }

  @override
  PaginationState<T> toError(Exception e) => PaginationState(
    state: PaginationStateType.error,
    data: const [],
    meta: null,
    exception: e,
    query: query.copyWith(page: 1),
  );

  @override
  PaginationState<T> toErrorMore(Exception e) => PaginationState(
    state: PaginationStateType.errorMore,
    data: data,
    meta: meta,
    exception: e,
    query: query,
  );

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(List<T> data) loadingMore,
    required R Function(List<T> data, MetaEntity? meta) success,
    required R Function(Exception exception) error,
    required R Function(List<T> data, Exception exception) errorMore,
  }) {
    return switch (state) {
      PaginationStateType.initial => initial(),
      PaginationStateType.loading => loading(),
      PaginationStateType.loadingMore => loadingMore(data),
      PaginationStateType.success => success(data, meta),
      PaginationStateType.error => error(exception!),
      PaginationStateType.errorMore => errorMore(data, exception!),
    };
  }

  @override
  String toString() =>
      'PaginationState($state, items: $itemCount, page: $currentPage/$totalPages, hasMore: $hasMore${exception != null ? ', error: $exception' : ''})';
}
