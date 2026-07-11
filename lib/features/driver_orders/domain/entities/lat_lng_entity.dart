import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// A simple geographic coordinate used across the driver route/map feature.
///
/// Kept independent from any map SDK type so the domain layer stays pure.
class LatLngEntity extends Equatable {
  final double lat;
  final double lng;

  const LatLngEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];

  // ---------------------------------------------------------------------------
  // Parsing helpers — the backend and Firebase store coordinates in several
  // different shapes, so these normalise all of them into a [LatLngEntity]:
  //   * a "lat,long" string (API `store.latLong`)
  //   * flat `lat` + `lng`/`long` fields (Firebase `customer`)
  //   * a nested `location`/`latLong` object
  //   * numeric values or numeric strings
  // ---------------------------------------------------------------------------

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  /// Parses a combined `"lat,long"` string (e.g. `"37.7749,-122.4194"`).
  static LatLngEntity? fromCombined(dynamic value) {
    if (value is! String) return null;
    final parts = value.split(',');
    if (parts.length != 2) return null;
    final lat = _toDouble(parts[0]);
    final lng = _toDouble(parts[1]);
    if (lat == null || lng == null) return null;
    return LatLngEntity(lat: lat, lng: lng);
  }

  /// Great-circle distance in meters between [a] and [b] (haversine formula).
  static double distanceMeters(LatLngEntity a, LatLngEntity b) {
    const earthRadiusMeters = 6371000.0;
    double toRad(double deg) => deg * math.pi / 180.0;

    final dLat = toRad(b.lat - a.lat);
    final dLng = toRad(b.lng - a.lng);
    final lat1 = toRad(a.lat);
    final lat2 = toRad(b.lat);

    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return earthRadiusMeters * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  /// Best-effort parse from any of the supported shapes. Returns null when no
  /// valid coordinate can be extracted.
  static LatLngEntity? fromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return fromCombined(value);
    if (value is Map) {
      // Nested object under `location` / `latLong`.
      final nested = value['location'] ?? value['latLong'] ?? value['latlong'];
      if (nested != null && nested != value) {
        final parsed = fromDynamic(nested);
        if (parsed != null) return parsed;
      }
      // Flat fields (Firebase uses `long`; others use `lng`/`longitude`).
      final lat = _toDouble(value['lat'] ?? value['latitude']);
      final lng = _toDouble(
        value['lng'] ?? value['long'] ?? value['longitude'],
      );
      if (lat != null && lng != null) return LatLngEntity(lat: lat, lng: lng);
    }
    return null;
  }
}
