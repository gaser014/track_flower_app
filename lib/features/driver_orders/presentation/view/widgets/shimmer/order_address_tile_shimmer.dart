import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/widgets/custom_shimmer_container.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';

class OrderAddressTileShimmer extends StatelessWidget {
  const OrderAddressTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomShimmerContainer(height: 12, width: 90, borderRadius: 4),
        const Gap(8),
        OrderSurface(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const CustomShimmerContainer(
                height: 44,
                width: 44,
                borderRadius: 22,
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomShimmerContainer(
                      height: 13,
                      width: 120,
                      borderRadius: 4,
                    ),
                    Gap(8),
                    CustomShimmerContainer(
                      height: 13,
                      width: double.infinity,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
