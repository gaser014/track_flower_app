import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_location_tile.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_pill_button.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';

class PendingOrderCard extends StatelessWidget {
  const PendingOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  final OrderEntity order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return OrderSurface(
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
          PickupAddressTile(store: order.store),
          const Gap(16),
          UserAddressTile(customer: order.customer),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${AppStrings.egp} ${order.totalPrice}",
                  style: AppFontStyle.semiBold14(
                    context: context,
                  ).copyWith(color: AppColors.black0C),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OrderPillButton(
                    label: AppStrings.reject,
                    filled: false,
                    onPressed: onReject,
                  ),
                  const Gap(8),
                  OrderPillButton(
                    label: AppStrings.accept,
                    filled: true,
                    onPressed: onAccept,
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
