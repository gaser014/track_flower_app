part of 'driver_orders_cubit.dart';

class DriverOrdersStates extends Equatable {
  final PaginationState<OrderEntity> pendingState;
  final PaginationState<OrderEntity> myOrdersState;
  final BaseState<OrderEntity> activeState;

  const DriverOrdersStates({
    this.pendingState = const PaginationState.initial(),
    this.myOrdersState = const PaginationState.initial(),
    this.activeState = const BaseState.initial(),
  });

  int get completedCount =>
      myOrdersState.data.where((o) => o.status == OrderStatus.completed).length;
  int get cancelledCount =>
      myOrdersState.data.where((o) => o.status == OrderStatus.cancelled).length;

  DriverOrdersStates copyWith({
    PaginationState<OrderEntity>? pendingState,
    PaginationState<OrderEntity>? myOrdersState,
    BaseState<OrderEntity>? activeState,
  }) => DriverOrdersStates(
    pendingState: pendingState ?? this.pendingState,
    myOrdersState: myOrdersState ?? this.myOrdersState,
    activeState: activeState ?? this.activeState,
  );

  @override
  List<Object?> get props => [pendingState, myOrdersState, activeState];
}
