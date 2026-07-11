import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

abstract class OrderRouteRepository {
  /// Builds the full route for one delivery leg:
  /// resolves the store & customer coordinates from the Firebase `orders`
  /// collection (falling back to on-device geocoding and caching the result
  /// back to Firebase), reads the driver's current GPS position as the origin,
  /// and fetches the route polyline for the [mode]'s destination.
  ///
  /// Google Maps cost is kept minimal: the Directions API is called at most
  /// once here, and a straight line is used as a free fallback on failure.
  Future<Result<OrderRouteEntity>> getOrderRoute({
    required OrderEntity order,
    required RouteMode mode,
  });

  /// Live driver position from the free on-device GPS (no Google API cost).
  Stream<LatLngEntity> watchDriverLocation();

  /// Writes the driver's current [location] to the Firebase `orders` document
  /// so the customer app can track it. Callers throttle this by distance to
  /// keep Firestore writes cheap.
  Future<void> updateDriverLocation({
    required String orderId,
    required LatLngEntity location,
  });
}
