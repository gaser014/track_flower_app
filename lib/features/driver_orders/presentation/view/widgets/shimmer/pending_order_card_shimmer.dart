import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/widgets/custom_shimmer_container.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/shimmer/order_address_tile_shimmer.dart';

class PendingOrderCardShimmer extends StatelessWidget {
  const PendingOrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomShimmerContainer(height: 14, width: 140, borderRadius: 4),
          Gap(16),
          OrderAddressTileShimmer(),
          Gap(16),
          OrderAddressTileShimmer(),
          Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerContainer(height: 16, width: 70, borderRadius: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomShimmerContainer(
                    height: 36,
                    width: 90,
                    borderRadius: 100,
                  ),
                  Gap(8),
                  CustomShimmerContainer(
                    height: 36,
                    width: 90,
                    borderRadius: 100,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PendingOrdersListShimmer extends StatelessWidget {
  const PendingOrdersListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) => const PendingOrderCardShimmer(),
    );
  }
}
