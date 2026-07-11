import 'dart:developer';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/firebase/order_tracking_service.dart';
import 'package:track_flowers_app/config/location/location_helper.dart';
import 'package:track_flowers_app/features/driver_orders/api/api_client/directions_api_client.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/order_route_repository.dart';

@LazySingleton(as: OrderRouteRepository)
class OrderRouteRepositoryImpl implements OrderRouteRepository {
  final OrderTrackingService _trackingService;
  final DirectionsApiClient _directionsApiClient;

  OrderRouteRepositoryImpl({
    required OrderTrackingService trackingService,
    required DirectionsApiClient directionsApiClient,
  }) : _trackingService = trackingService,
       _directionsApiClient = directionsApiClient;

  static const String _logName = 'OrderRouteRepository';

  @override
  Future<Result<OrderRouteEntity>> getOrderRoute({
    required OrderEntity order,
    required RouteMode mode,
  }) async {
    // 1. Location data: Firebase `orders` collection first, then the
    //    coordinates that came from the backend order (API `store.latLong`,
    //    customer shipping address, etc.).
    final firebaseData = await _trackingService.getOrderData(order.id);

    var storeLocation =
        LatLngEntity.fromDynamic(firebaseData?['store']) ??
        order.store.location;
    var userLocation =
        LatLngEntity.fromDynamic(firebaseData?['customer']) ??
        order.customer.location;

    // 2. Fall back to free on-device geocoding for any still-missing endpoint,
    //    then cache the resolved coordinates back to Firebase so we never
    //    geocode the same address twice.
    if (storeLocation == null && order.store.address.isNotEmpty) {
      storeLocation = await _geocode(order.store.address);
      if (storeLocation != null) {
        await _cacheLocation(order.id, 'store', storeLocation);
      }
    }
    if (userLocation == null && order.customer.address.isNotEmpty) {
      userLocation = await _geocode(order.customer.address);
      if (userLocation != null) {
        await _cacheLocation(order.id, 'customer', userLocation);
      }
    }

    // 3. Origin = driver's current position (device GPS), with the Firebase
    //    mirrored driver location as a fallback.
    final origin =
        await _currentDeviceLocation() ??
        LatLngEntity.fromDynamic(firebaseData?['driverLocation']) ??
        LatLngEntity.fromDynamic(firebaseData?['driver']);

    final destination = mode == RouteMode.pickup ? storeLocation : userLocation;

    // 4. Draw the route. Directions API is called at most once; on any failure
    //    we fall back to a free straight line so no cost is wasted retrying.
    var polyline = <LatLngEntity>[];
    var distanceText = '';
    var durationText = '';
    var isFallback = false;

    if (origin != null && destination != null) {
      final directions = await _fetchDirections(origin, destination);
      if (directions != null && directions.points.isNotEmpty) {
        polyline = directions.points;
        distanceText = directions.distanceText;
        durationText = directions.durationText;
      } else {
        polyline = [origin, destination];
        distanceText = _straightLineDistanceText(origin, destination);
        isFallback = true;
      }
    }

    return Success(
      data: OrderRouteEntity(
        origin: origin,
        storeLocation: storeLocation,
        userLocation: userLocation,
        polyline: polyline,
        distanceText: distanceText,
        durationText: durationText,
        isFallbackRoute: isFallback,
      ),
    );
  }

  @override
  Future<void> updateDriverLocation({
    required String orderId,
    required LatLngEntity location,
  }) {
    return _trackingService.updateDriverLocation(
      orderId: orderId,
      lat: location.lat,
      lng: location.lng,
    );
  }

  @override
  Stream<LatLngEntity> watchDriverLocation() async* {
    try {
      final stream = await LocationHelper.instance.watchUserLocation();
      yield* stream
          .where((data) => data.latitude != null && data.longitude != null)
          .map(
            (data) => LatLngEntity(lat: data.latitude!, lng: data.longitude!),
          );
    } catch (e) {
      log('watchDriverLocation failed: $e', name: _logName);
    }
  }

  // --------------------------------------------------------------------------
  // Helpers
  // --------------------------------------------------------------------------

  Future<LatLngEntity?> _geocode(String address) async {
    try {
      final results = await geo.locationFromAddress(address);
      if (results.isEmpty) return null;
      final first = results.first;
      return LatLngEntity(lat: first.latitude, lng: first.longitude);
    } catch (e) {
      log('geocode failed for "$address": $e', name: _logName);
      return null;
    }
  }

  Future<void> _cacheLocation(
    String orderId,
    String field,
    LatLngEntity location,
  ) async {
    await _trackingService.upsertOrder(orderId, {
      field: {
        'location': {'lat': location.lat, 'lng': location.lng},
      },
    });
  }

  Future<LatLngEntity?> _currentDeviceLocation() async {
    try {
      final data = await LocationHelper.instance.getUserLocation();
      if (data.latitude == null || data.longitude == null) return null;
      return LatLngEntity(lat: data.latitude!, lng: data.longitude!);
    } catch (e) {
      log('device location failed: $e', name: _logName);
      return null;
    }
  }

  Future<_DirectionsData?> _fetchDirections(
    LatLngEntity origin,
    LatLngEntity destination,
  ) async {
    try {
      final result = await _directionsApiClient.getRoute(
        origin: origin,
        destination: destination,
      );
      return _DirectionsData(
        result.points,
        result.distanceText,
        result.durationText,
      );
    } catch (e) {
      log('directions request failed: $e', name: _logName);
      return null;
    }
  }

  String _straightLineDistanceText(LatLngEntity a, LatLngEntity b) {
    final meters = LatLngEntity.distanceMeters(a, b);
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _DirectionsData {
  final List<LatLngEntity> points;
  final String distanceText;
  final String durationText;

  const _DirectionsData(this.points, this.distanceText, this.durationText);
}
