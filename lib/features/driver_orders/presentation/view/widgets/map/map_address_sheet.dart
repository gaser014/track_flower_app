import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_location_tile.dart';

/// Bottom panel from the Figma designs: a grab handle plus the pickup and user
/// address cards. Card order follows the leg being shown:
/// * pickup   → pickup card first, then user card.
/// * delivery → user card first, then pickup card.
class MapAddressSheet extends StatelessWidget {
  const MapAddressSheet({super.key, required this.order, required this.mode});

  final OrderEntity order;
  final RouteMode mode;

  @override
  Widget build(BuildContext context) {
    final pickup = PickupAddressTile(store: order.store, showActions: true);
    final user = UserAddressTile(customer: order.customer, showActions: true);

    final cards = mode == RouteMode.pickup
        ? [pickup, user]
        : [user, pickup];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteF9,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray10,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(24),
              cards.first,
              const Gap(24),
              cards.last,
            ],
          ),
        ),
      ),
    );
  }
}
