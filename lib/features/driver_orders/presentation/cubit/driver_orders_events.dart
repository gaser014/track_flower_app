part of 'driver_orders_cubit.dart';

sealed class DriverOrdersEvents {
  const DriverOrdersEvents();
}

class GetPendingOrdersEvent extends DriverOrdersEvents {
  const GetPendingOrdersEvent();
}

class LoadMorePendingOrdersEvent extends DriverOrdersEvents {
  const LoadMorePendingOrdersEvent();
}

class GetMyOrdersEvent extends DriverOrdersEvents {
  const GetMyOrdersEvent();
}

class LoadMoreMyOrdersEvent extends DriverOrdersEvents {
  const LoadMoreMyOrdersEvent();
}

class GetActiveOrderEvent extends DriverOrdersEvents {
  const GetActiveOrderEvent();
}

class SetActiveOrderEvent extends DriverOrdersEvents {
  final OrderEntity order;
  const SetActiveOrderEvent(this.order);
}

class AcceptOrderEvent extends DriverOrdersEvents {
  final OrderEntity order;
  const AcceptOrderEvent(this.order);
}

class RejectOrderEvent extends DriverOrdersEvents {
  final OrderEntity order;
  const RejectOrderEvent(this.order);
}

class AdvanceOrderEvent extends DriverOrdersEvents {
  const AdvanceOrderEvent();
}

sealed class DriverOrdersUiEvent {
  const DriverOrdersUiEvent();
}

class OpenOrderDetailsUiEvent extends DriverOrdersUiEvent {
  final OrderEntity order;
  const OpenOrderDetailsUiEvent(this.order);
}

class ActiveOrderWarningUiEvent extends DriverOrdersUiEvent {
  const ActiveOrderWarningUiEvent();
}
