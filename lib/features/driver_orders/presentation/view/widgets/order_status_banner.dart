import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

class OrderStatusBanner extends StatelessWidget {
  const OrderStatusBanner({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'EEE, dd MMM yyyy, hh:mm a',
    ).format(order.date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pinkF9,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${AppStrings.status} : ",
                style: AppFontStyle.medium14(context: context),
              ),
              Text(
                order.status.ui.label,
                style: AppFontStyle.medium14(
                  context: context,
                ).copyWith(color: order.status.ui.color),
              ),
            ],
          ),
          const Gap(8),
          Text(
            "${AppStrings.orderId} : # ${order.id}",
            style: AppFontStyle.semiBold14(context: context),
          ),
          const Gap(4),
          Text(
            formattedDate,
            style: AppFontStyle.regular13(
              context: context,
            ).copyWith(color: AppColors.gray53),
          ),
        ],
      ),
    );
  }
}
