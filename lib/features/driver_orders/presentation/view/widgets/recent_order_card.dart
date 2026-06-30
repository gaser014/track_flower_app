import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_location_tile.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_status_label.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';

class RecentOrderCard extends StatelessWidget {
  const RecentOrderCard({super.key, required this.order, this.onTap});

  final OrderEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: OrderSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.type,
              style: AppFontStyle.medium14(
                context: context,
              ).copyWith(color: AppColors.black0C),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderStatusLabel(status: order.status),
                Text(
                  "# ${order.orderNumber}",
                  style: AppFontStyle.semiBold16(context: context),
                ),
              ],
            ),
            const Gap(16),
            PickupAddressTile(store: order.store),
            const Gap(16),
            UserAddressTile(customer: order.customer),
          ],
        ),
      ),
    );
  }
}
