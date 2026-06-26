import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_cached_image.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    return OrderSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.image.isEmpty
              ? CircleAvatar(
                  backgroundColor: AppColors.pinkF9,
                  child: const Icon(
                    Icons.local_florist,
                    color: AppColors.primerColor,
                    size: 20,
                  ),
                )
              : CircleAvatar(
                  radius: 20,
                  child: CustomCachedImage(
                    imagePath: item.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppFontStyle.regular13(context: context),
                ),
                const Gap(4),
                Text(
                  "${AppStrings.egp} ${item.price}",
                  style: AppFontStyle.semiBold13(context: context),
                ),
              ],
            ),
          ),
          const Gap(8),
          Text(
            "X${item.quantity}",
            style: AppFontStyle.medium13(
              context: context,
            ).copyWith(color: AppColors.redCC),
          ),
        ],
      ),
    );
  }
}
