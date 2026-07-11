import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_order_route_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/update_driver_location_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/watch_driver_location_use_case.dart';

part 'order_route_events.dart';
part 'order_route_states.dart';

/// Drives the two Figma map screens (pickup + delivery).
///
/// Cost strategy: the Directions API is requested a single time per screen
/// (in [_loadOrderRoute]). Afterwards the driver marker moves purely from the
/// free GPS stream — location updates never trigger a new Directions call.
/// The live position is also written to Firebase, but only after the driver
/// has moved at least [_locationWriteThresholdMeters] to keep writes cheap.
@injectable
class OrderRouteCubit extends Cubit<OrderRouteStates> {
  final GetOrderRouteUseCase _getOrderRouteUseCase;
  final WatchDriverLocationUseCase _watchDriverLocationUseCase;
  final UpdateDriverLocationUseCase _updateDriverLocationUseCase;

  OrderRouteCubit({
    required GetOrderRouteUseCase getOrderRouteUseCase,
    required WatchDriverLocationUseCase watchDriverLocationUseCase,
    required UpdateDriverLocationUseCase updateDriverLocationUseCase,
  }) : _getOrderRouteUseCase = getOrderRouteUseCase,
       _watchDriverLocationUseCase = watchDriverLocationUseCase,
       _updateDriverLocationUseCase = updateDriverLocationUseCase,
       super(const OrderRouteStates());

  /// Minimum distance the driver must move before we write to Firebase again.
  static const double _locationWriteThresholdMeters = 300;

  /// How close (in meters) the driver must get to the destination before we
  /// consider them "arrived", stop tracking, and prompt a status update.
  static const double _arrivalThresholdMeters = 80;

  StreamSubscription<LatLngEntity>? _locationSub;

  /// The order currently shown, needed to know which Firebase doc to update.
  OrderEntity? _order;

  /// Which leg is being tracked, so we know the destination to arrive at.
  RouteMode _mode = RouteMode.delivery;

  /// Last position we persisted to Firebase (null until the first write).
  LatLngEntity? _lastWrittenLocation;

  /// Guards arrival handling so it only fires once per screen.
  bool _arrivalHandled = false;

  @override
  void emit(OrderRouteStates state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> doIntent(OrderRouteEvents event) async => switch (event) {
    LoadOrderRouteEvent() => _loadOrderRoute(event),
    DriverLocationChangedEvent() => _onDriverLocationChanged(event),
  };

  Future<void> _loadOrderRoute(LoadOrderRouteEvent event) async {
    if (state.routeState.isLoading) return;
    _order = event.order;
    _mode = event.mode;
    _arrivalHandled = false;
    emit(state.copyWith(routeState: const BaseState.loading()));

    final result = await _getOrderRouteUseCase(
      GetOrderRouteParams(order: event.order, mode: event.mode),
    );

    result.when(
      success: (data) {
        if (data == null) {
          emit(
            state.copyWith(
              routeState: BaseState.error(Exception('No route data')),
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            routeState: BaseState.success(data),
            liveDriverLocation: data.origin,
          ),
        );
        // Push an initial position so the customer sees the driver right away.
        if (data.origin != null) _persistDriverLocation(data.origin!);
        _listenToDriverLocation();
      },
      error: (e) => emit(
        state.copyWith(routeState: BaseState.error(e ?? Exception('Unknown'))),
      ),
    );
  }

  void _listenToDriverLocation() {
    _locationSub?.cancel();
    _locationSub = _watchDriverLocationUseCase().listen(
      (location) => doIntent(DriverLocationChangedEvent(location)),
    );
  }

  Future<void> _onDriverLocationChanged(
    DriverLocationChangedEvent event,
  ) async {
    if (_arrivalHandled) return;

    // Reached the destination: write the final position, stop the GPS stream
    // (no more tracking / Firebase writes) and flag arrival so the UI can
    // prompt a status update.
    if (_isNearDestination(event.location)) {
      _arrivalHandled = true;
      _persistDriverLocation(event.location);
      _locationSub?.cancel();
      emit(
        state.copyWith(liveDriverLocation: event.location, hasArrived: true),
      );
      return;
    }

    // Only the live marker moves; the cached route/polyline stays as-is to
    // avoid extra (paid) Directions requests.
    emit(state.copyWith(liveDriverLocation: event.location));

    // Mirror to Firebase only after the driver has moved far enough, so the
    // customer app gets fresh tracking without spamming Firestore writes.
    final last = _lastWrittenLocation;
    if (last == null ||
        LatLngEntity.distanceMeters(last, event.location) >=
            _locationWriteThresholdMeters) {
      _persistDriverLocation(event.location);
    }
  }

  /// Whether [location] is within the arrival radius of the current leg's
  /// destination (store for pickup, customer for delivery).
  bool _isNearDestination(LatLngEntity location) {
    final destination = state.routeState.data?.destinationFor(_mode);
    if (destination == null) return false;
    return LatLngEntity.distanceMeters(location, destination) <=
        _arrivalThresholdMeters;
  }

  void _persistDriverLocation(LatLngEntity location) {
    final orderId = _order?.id;
    if (orderId == null || orderId.isEmpty) return;
    _lastWrittenLocation = location;
    _updateDriverLocationUseCase(orderId: orderId, location: location);
  }

  @override
  Future<void> close() {
    _locationSub?.cancel();
    return super.close();
  }
}
