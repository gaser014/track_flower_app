part of 'order_route_cubit.dart';

class OrderRouteStates extends Equatable {
  /// The resolved route (origin, endpoints, polyline). Loading while building.
  final BaseState<OrderRouteEntity> routeState;

  /// The driver's latest live position from GPS (drives the moving marker).
  /// Kept separate so location updates never re-trigger a Directions request.
  final LatLngEntity? liveDriverLocation;

  /// True once the driver reaches the destination. When set, live tracking is
  /// stopped and the UI prompts the driver to update the order status.
  final bool hasArrived;

  const OrderRouteStates({
    this.routeState = const BaseState.initial(),
    this.liveDriverLocation,
    this.hasArrived = false,
  });

  OrderRouteStates copyWith({
    BaseState<OrderRouteEntity>? routeState,
    LatLngEntity? liveDriverLocation,
    bool? hasArrived,
  }) {
    return OrderRouteStates(
      routeState: routeState ?? this.routeState,
      liveDriverLocation: liveDriverLocation ?? this.liveDriverLocation,
      hasArrived: hasArrived ?? this.hasArrived,
    );
  }

  @override
  List<Object?> get props => [routeState, liveDriverLocation, hasArrived];
}
