import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/map_marker_factory.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/route_polyline_utils.dart';

/// Renders the Google Map for one delivery leg: the driver marker, the
/// destination marker (store or user), and the pink route polyline.
///
/// The map SDK render itself is free on mobile; the polyline points are
/// supplied by the cubit (fetched once), so this widget makes no API calls.
class RouteMapView extends StatefulWidget {
  const RouteMapView({
    super.key,
    required this.route,
    required this.mode,
    required this.driverLocation,
  });

  final OrderRouteEntity route;
  final RouteMode mode;

  /// Live driver position (moves the driver marker between route fetches).
  final LatLngEntity? driverLocation;

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  BitmapDescriptor? _driverIcon;
  BitmapDescriptor? _destinationIcon;

  static const LatLng _fallbackTarget = LatLng(30.0444, 31.2357); // Cairo

  @override
  void initState() {
    super.initState();
    _buildIcons();
  }

  Future<void> _buildIcons() async {
    final driver = await MapMarkerFactory.svgMarker(
      assetPath: AppAssets.motorcycleDelivery,
      rotationDegrees: 90,
    );
    final destination = await MapMarkerFactory.pillMarker(
      label: widget.mode == RouteMode.pickup
          ? AppStrings.appTitle
          : AppStrings.user,

      icon: widget.mode == RouteMode.pickup ? Icons.local_florist : Icons.home,
    );
    if (!mounted) return;
    setState(() {
      _driverIcon = driver;
      _destinationIcon = destination;
    });
  }

  LatLng? get _driverLatLng {
    final d = widget.driverLocation ?? widget.route.origin;
    return d == null ? null : LatLng(d.lat, d.lng);
  }

  LatLng? get _destinationLatLng {
    final dest = widget.route.destinationFor(widget.mode);
    return dest == null ? null : LatLng(dest.lat, dest.lng);
  }

  double get _driverRotation {
    final polyline = widget.route.polyline;
    final driver = widget.driverLocation ?? widget.route.origin;
    final destination = widget.route.destinationFor(widget.mode);

    if (driver != null && polyline.length >= 2) {
      return RoutePolylineUtils.motorcycleRotation(
        RoutePolylineUtils.headingTowardDestination(
          polyline: polyline,
          position: driver,
          destination: destination,
        ),
      );
    }

    if (destination != null && driver != null) {
      return RoutePolylineUtils.motorcycleRotation(
        RoutePolylineUtils.bearingDegrees(driver, destination),
      );
    }

    if (polyline.length >= 2) {
      return RoutePolylineUtils.motorcycleRotation(
        RoutePolylineUtils.bearingDegrees(polyline.first, polyline.last),
      );
    }

    return 0;
  }

  Set<Marker> get _markers {
    final markers = <Marker>{};
    final driver = _driverLatLng;
    if (driver != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: driver,
          icon: _driverIcon ?? BitmapDescriptor.defaultMarker,
          rotation: _driverRotation,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }
    final destination = _destinationLatLng;
    if (destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: _destinationIcon ?? BitmapDescriptor.defaultMarker,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }
    return markers;
  }

  Set<Polyline> get _polylines {
    final points = widget.route.polyline;
    if (points.length < 2) return {};

    final latLngPoints = points.map((p) => LatLng(p.lat, p.lng)).toList();
    final driver = widget.driverLocation;

    if (driver == null) {
      return {
        Polyline(
          polylineId: const PolylineId('route_remaining'),
          color: AppColors.primerColor,
          width: 4,
          points: latLngPoints,
        ),
      };
    }

    final split = RoutePolylineUtils.splitAtPosition(
      polyline: points,
      position: driver,
      destination: widget.route.destinationFor(widget.mode),
    );
    if (split == null) {
      return {
        Polyline(
          polylineId: const PolylineId('route_remaining'),
          color: AppColors.primerColor,
          width: 4,
          points: latLngPoints,
        ),
      };
    }

    final polylines = <Polyline>{};
    final traveled = split.traveled
        .map((p) => LatLng(p.lat, p.lng))
        .toList(growable: false);
    final remaining = split.remaining
        .map((p) => LatLng(p.lat, p.lng))
        .toList(growable: false);

    if (RoutePolylineUtils.hasMeaningfulTraveledPath(split.traveled)) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_traveled'),
          color: AppColors.grayA6,
          width: 4,
          points: traveled,
        ),
      );
    }

    if (remaining.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_remaining'),
          color: AppColors.primerColor,
          width: 4,
          points: remaining,
        ),
      );
    }

    return polylines;
  }

  @override
  void didUpdateWidget(covariant RouteMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverLocation != widget.driverLocation) {
      // Keep the driver marker in view as it moves.
      _animateToDriver();
    }
  }

  Future<void> _animateToDriver() async {
    final driver = _driverLatLng;
    if (driver == null || !_controller.isCompleted) return;
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(driver));
  }

  Future<void> _fitBounds() async {
    final controller = await _controller.future;
    final points = <LatLng>[
      ?_driverLatLng,
      ?_destinationLatLng,
      ...widget.route.polyline.map((p) => LatLng(p.lat, p.lng)),
    ];

    if (points.isEmpty) return;
    if (points.length == 1) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 15),
      );
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      minLat = p.latitude < minLat ? p.latitude : minLat;
      maxLat = p.latitude > maxLat ? p.latitude : maxLat;
      minLng = p.longitude < minLng ? p.longitude : minLng;
      maxLng = p.longitude > maxLng ? p.longitude : maxLng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    final target = _driverLatLng ?? _destinationLatLng ?? _fallbackTarget;
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: target, zoom: 14),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (controller) {
        if (!_controller.isCompleted) _controller.complete(controller);
        _fitBounds();
      },
    );
  }
}
