import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

class OrderStatusLabel extends StatelessWidget {
  const OrderStatusLabel({super.key, required this.status, this.fontSize = 16});

  final OrderStatus status;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status.ui.icon != null) ...[
          Icon(status.ui.icon, size: 24, color: status.ui.color),
          const Gap(4),
        ],
        Text(
          status.ui.label,
          style: AppFontStyle.medium16(
            context: context,
          ).copyWith(color: status.ui.color, fontSize: fontSize),
        ),
      ],
    );
  }
}
