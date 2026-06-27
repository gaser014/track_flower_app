import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

class OrderStepsIndicator extends StatelessWidget {
  const OrderStepsIndicator({super.key, required this.status, this.steps = 4});

  final OrderStatus status;
  final int steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps, (index) {
        final reached = index < status.step;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == steps - 1 ? 0 : 8),
            decoration: BoxDecoration(
              color: reached ? AppColors.green0C : AppColors.grayCF,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
