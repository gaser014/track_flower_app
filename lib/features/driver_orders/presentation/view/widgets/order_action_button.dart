import 'package:flutter/material.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_pill_button.dart';

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  final OrderStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (status.ui.actionLabel.isEmpty) return const SizedBox.shrink();
    return OrderPillButton(
      label: status.ui.actionLabel,
      filled: true,
      expanded: true,
      height: 52,
      onPressed: status.ui.canAdvance ? onPressed : null,
    );
  }
}
