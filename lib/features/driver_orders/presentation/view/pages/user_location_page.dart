import 'package:flutter/material.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/pages/order_route_map_page.dart';

/// Figma "User location" screen (node 97:3313): route from the driver to the
/// customer.
class UserLocationPage extends StatelessWidget {
  const UserLocationPage({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return OrderRouteMapPage(order: order, mode: RouteMode.delivery);
  }
}
