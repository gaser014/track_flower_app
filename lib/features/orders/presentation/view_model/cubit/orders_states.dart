part of 'orders_cubit.dart';

class OrdersStates extends Equatable {
  /// Holds the accumulated list of orders across loaded pages.
  final BaseState<List<OrderEntity>> ordersState;

  /// Pagination metadata for the most recently loaded page.
  final MetaEntity meta;

  /// True while appending the next page (keeps the existing list visible).
  final bool isLoadingMore;

  const OrdersStates({
    this.ordersState = const BaseState.initial(),
    this.meta = const MetaEntity.empty(),
    this.isLoadingMore = false,
  });

  OrdersStates copyWith({
    BaseState<List<OrderEntity>>? ordersState,
    MetaEntity? meta,
    bool? isLoadingMore,
  }) {
    return OrdersStates(
      ordersState: ordersState ?? this.ordersState,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [ordersState, meta, isLoadingMore];
}
