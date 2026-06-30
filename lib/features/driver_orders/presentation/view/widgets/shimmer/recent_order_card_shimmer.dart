import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/widgets/custom_shimmer_container.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/shimmer/order_address_tile_shimmer.dart';

class RecentOrderCardShimmer extends StatelessWidget {
  const RecentOrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomShimmerContainer(height: 14, width: 140, borderRadius: 4),
          Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerContainer(height: 16, width: 90, borderRadius: 4),
              CustomShimmerContainer(height: 16, width: 70, borderRadius: 4),
            ],
          ),
          Gap(16),
          OrderAddressTileShimmer(),
          Gap(16),
          OrderAddressTileShimmer(),
        ],
      ),
    );
  }
}

class RecentOrdersListShimmer extends StatelessWidget {
  const RecentOrdersListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const RecentOrderCardShimmer(),
    );
  }
}
