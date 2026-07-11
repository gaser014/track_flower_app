import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';

/// Which leg of the delivery the map is drawing.
///
/// * [pickup]   → route from the driver to the Flowery store.
/// * [delivery] → route from the driver to the customer.
enum RouteMode { pickup, delivery }

/// Everything the map screen needs to render a single delivery leg:
/// the driver origin, both endpoints (store + user) for markers, and the
/// pre-computed route polyline plus its distance/duration labels.
class OrderRouteEntity extends Equatable {
  /// Driver's current position (route origin). Null when GPS is unavailable.
  final LatLngEntity? origin;

  /// Flowery store coordinates (sourced from the Firebase order document).
  final LatLngEntity? storeLocation;

  /// Customer coordinates (sourced from the Firebase order document).
  final LatLngEntity? userLocation;

  /// The route geometry from [origin] to the mode's destination.
  final List<LatLngEntity> polyline;

  /// Human readable distance, e.g. "3.2 km". Empty when unknown.
  final String distanceText;

  /// Human readable duration, e.g. "12 min". Empty when unknown.
  final String durationText;

  /// True when [polyline] is a straight fallback line rather than a real
  /// Directions API result (used to keep Google Maps usage cheap on failure).
  final bool isFallbackRoute;

  const OrderRouteEntity({
    this.origin,
    this.storeLocation,
    this.userLocation,
    this.polyline = const [],
    this.distanceText = '',
    this.durationText = '',
    this.isFallbackRoute = false,
  });

  /// The destination for the given [mode].
  LatLngEntity? destinationFor(RouteMode mode) =>
      mode == RouteMode.pickup ? storeLocation : userLocation;

  OrderRouteEntity copyWith({
    LatLngEntity? origin,
    LatLngEntity? storeLocation,
    LatLngEntity? userLocation,
    List<LatLngEntity>? polyline,
    String? distanceText,
    String? durationText,
    bool? isFallbackRoute,
  }) {
    return OrderRouteEntity(
      origin: origin ?? this.origin,
      storeLocation: storeLocation ?? this.storeLocation,
      userLocation: userLocation ?? this.userLocation,
      polyline: polyline ?? this.polyline,
      distanceText: distanceText ?? this.distanceText,
      durationText: durationText ?? this.durationText,
      isFallbackRoute: isFallbackRoute ?? this.isFallbackRoute,
    );
  }

  @override
  List<Object?> get props => [
    origin,
    storeLocation,
    userLocation,
    polyline,
    distanceText,
    durationText,
    isFallbackRoute,
  ];
}
