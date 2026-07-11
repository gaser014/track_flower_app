part of 'order_route_cubit.dart';

sealed class OrderRouteEvents {
  const OrderRouteEvents();
}

/// Build the route once for the given order + leg (calls Directions at most
/// once) and start listening to live driver-location updates.
class LoadOrderRouteEvent extends OrderRouteEvents {
  final OrderEntity order;
  final RouteMode mode;

  const LoadOrderRouteEvent({required this.order, required this.mode});
}

/// Emitted internally whenever a new GPS fix arrives for the driver.
class DriverLocationChangedEvent extends OrderRouteEvents {
  final LatLngEntity location;

  const DriverLocationChangedEvent(this.location);
}
