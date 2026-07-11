import 'dart:math' as math;

import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';

/// Where the driver sits along a route polyline and which way they are heading.
class RoutePolylineProgress {
  const RoutePolylineProgress({
    required this.segmentIndex,
    required this.point,
    required this.bearing,
  });

  /// Index of the polyline segment that contains [point].
  final int segmentIndex;

  /// Closest point on the route to the driver's live GPS position.
  final LatLngEntity point;

  /// Clockwise degrees from true north along the current segment toward the destination.
  final double bearing;
}

/// Geometry helpers for snapping the driver to a route and styling progress.
abstract class RoutePolylineUtils {
  /// The motorcycle bitmap is pre-rotated 90° when baked, so it faces north at rotation 0.
  static const double motorcycleIconHeadingOffset = 0;

  /// Minimum traveled distance before the achieved segment is drawn in gray.
  static const double minTraveledMeters = 8;

  /// Minimum distance to a look-ahead point before using it for icon rotation.
  static const double minHeadingTargetMeters = 5;

  /// Bearing in degrees clockwise from true north between [from] and [to].
  static double bearingDegrees(LatLngEntity from, LatLngEntity to) {
    double toRad(double deg) => deg * math.pi / 180.0;
    double toDeg(double rad) => rad * 180.0 / math.pi;

    final lat1 = toRad(from.lat);
    final lat2 = toRad(to.lat);
    final dLng = toRad(to.lng - from.lng);

    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    return (toDeg(math.atan2(y, x)) + 360) % 360;
  }

  /// Marker rotation so the motorcycle points along the route toward [destination].
  static double motorcycleRotation(double routeBearing) {
    return (routeBearing - motorcycleIconHeadingOffset + 360) % 360;
  }

  /// Bearing from [position] along the untraveled route toward [destination].
  static double headingTowardDestination({
    required List<LatLngEntity> polyline,
    required LatLngEntity position,
    LatLngEntity? destination,
  }) {
    if (destination != null) {
      final toDestination = bearingDegrees(position, destination);

      final split = splitAtPosition(polyline: polyline, position: position);
      if (split != null && split.remaining.length >= 2) {
        final alongRoute = _bearingAlongPath(position, split.remaining);
        if (_angularDifference(alongRoute, toDestination) <= 90) {
          return alongRoute;
        }
      }

      return toDestination;
    }

    final split = splitAtPosition(polyline: polyline, position: position);
    if (split != null && split.remaining.length >= 2) {
      return _bearingAlongPath(position, split.remaining);
    }

    if (polyline.length >= 2) {
      return bearingDegrees(polyline.first, polyline.last);
    }

    return 0;
  }

  /// Finds the closest point on [polyline] to [position] and the segment bearing.
  static RoutePolylineProgress? progressOnRoute({
    required List<LatLngEntity> polyline,
    required LatLngEntity position,
    LatLngEntity? destination,
  }) {
    if (polyline.length < 2) return null;

    final target = destination ?? polyline.last;

    var bestDistance = double.infinity;
    var bestSegmentIndex = 0;
    var bestPoint = polyline.first;
    var bestAlongTrack = -1.0;

    var cumulative = 0.0;
    for (var i = 0; i < polyline.length - 1; i++) {
      final segmentStart = polyline[i];
      final segmentEnd = polyline[i + 1];
      final projected = _closestPointOnSegment(
        position,
        segmentStart,
        segmentEnd,
      );
      final distance = LatLngEntity.distanceMeters(position, projected);
      final alongTrack =
          cumulative + LatLngEntity.distanceMeters(segmentStart, projected);

      final isBetter =
          distance < bestDistance - 2 ||
          (distance <= bestDistance + 12 && alongTrack > bestAlongTrack);

      if (isBetter) {
        bestDistance = distance;
        bestSegmentIndex = i;
        bestPoint = projected;
        bestAlongTrack = alongTrack;
      }

      cumulative += LatLngEntity.distanceMeters(segmentStart, segmentEnd);
    }

    final segmentStart = polyline[bestSegmentIndex];
    final segmentEnd = polyline[bestSegmentIndex + 1];
    final forward = bearingDegrees(segmentStart, segmentEnd);
    final backward = bearingDegrees(segmentEnd, segmentStart);
    final towardDestination = bearingDegrees(bestPoint, target);
    final bearing = _angularDifference(forward, towardDestination) <=
            _angularDifference(backward, towardDestination)
        ? forward
        : backward;

    return RoutePolylineProgress(
      segmentIndex: bestSegmentIndex,
      point: bestPoint,
      bearing: bearing,
    );
  }

  /// Splits [polyline] into traveled (gray) and remaining (pink) legs.
  static ({
    List<LatLngEntity> traveled,
    List<LatLngEntity> remaining,
    RoutePolylineProgress progress,
  })? splitAtPosition({
    required List<LatLngEntity> polyline,
    required LatLngEntity position,
    LatLngEntity? destination,
  }) {
    final progress = progressOnRoute(
      polyline: polyline,
      position: position,
      destination: destination,
    );
    if (progress == null) return null;

    final traveled = <LatLngEntity>[
      ...polyline.sublist(0, progress.segmentIndex + 1),
      progress.point,
    ];

    final remaining = <LatLngEntity>[
      progress.point,
      ...polyline.sublist(progress.segmentIndex + 1),
    ];

    return (traveled: traveled, remaining: remaining, progress: progress);
  }

  static bool hasMeaningfulTraveledPath(List<LatLngEntity> traveled) {
    if (traveled.length < 2) return false;
    return LatLngEntity.distanceMeters(traveled.first, traveled.last) >=
        minTraveledMeters;
  }

  static double _bearingAlongPath(
    LatLngEntity position,
    List<LatLngEntity> path,
  ) {
    for (var i = 1; i < path.length; i++) {
      final target = path[i];
      if (LatLngEntity.distanceMeters(position, target) >=
          minHeadingTargetMeters) {
        return bearingDegrees(position, target);
      }
    }

    return bearingDegrees(position, path.last);
  }

  static double _angularDifference(double a, double b) {
    final diff = (a - b).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }

  static LatLngEntity _closestPointOnSegment(
    LatLngEntity point,
    LatLngEntity start,
    LatLngEntity end,
  ) {
    final dx = end.lng - start.lng;
    final dy = end.lat - start.lat;
    if (dx == 0 && dy == 0) return start;

    final t = ((point.lng - start.lng) * dx + (point.lat - start.lat) * dy) /
        (dx * dx + dy * dy);

    final clamped = t.clamp(0.0, 1.0);
    return LatLngEntity(
      lat: start.lat + clamped * dy,
      lng: start.lng + clamped * dx,
    );
  }
}
