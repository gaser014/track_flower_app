import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';

/// Parsed result of a Google Directions API response for a single route.
class DirectionsResultModel {
  final List<LatLngEntity> points;
  final String distanceText;
  final String durationText;

  const DirectionsResultModel({
    required this.points,
    this.distanceText = '',
    this.durationText = '',
  });

  bool get isEmpty => points.isEmpty;

  /// Builds the model from the raw `/directions/json` payload.
  ///
  /// Returns an empty result when the API reports anything other than `OK`
  /// (e.g. `ZERO_RESULTS`, `REQUEST_DENIED`) so callers can fall back cheaply.
  factory DirectionsResultModel.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? '').toString();
    final routes = json['routes'];
    if (status != 'OK' || routes is! List || routes.isEmpty) {
      return const DirectionsResultModel(points: []);
    }

    final route = routes.first as Map<String, dynamic>;
    final overview = route['overview_polyline'];
    final encoded = overview is Map ? (overview['points'] ?? '').toString() : '';

    String distanceText = '';
    String durationText = '';
    final legs = route['legs'];
    if (legs is List && legs.isNotEmpty) {
      final leg = legs.first as Map<String, dynamic>;
      final distance = leg['distance'];
      final duration = leg['duration'];
      if (distance is Map) distanceText = (distance['text'] ?? '').toString();
      if (duration is Map) durationText = (duration['text'] ?? '').toString();
    }

    return DirectionsResultModel(
      points: decodePolyline(encoded),
      distanceText: distanceText,
      durationText: durationText,
    );
  }

  /// Decodes an [encoded] Google "Encoded Polyline Algorithm" string into a
  /// list of coordinates. Pure math — no network or SDK dependency.
  static List<LatLngEntity> decodePolyline(String encoded) {
    final points = <LatLngEntity>[];
    if (encoded.isEmpty) return points;

    int index = 0;
    final int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLngEntity(lat: lat / 1e5, lng: lng / 1e5));
    }

    return points;
  }
}
