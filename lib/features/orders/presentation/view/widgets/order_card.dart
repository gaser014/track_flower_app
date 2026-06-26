import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/orders/domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowBox,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.orderNumber.isNotEmpty
                      ? "#${order.orderNumber}"
                      : AppStrings.orders,
                  style: AppFontStyle.semiBold16(context: context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusChip(state: order.state),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: AppStrings.totalPrice,
            value: "${order.totalPrice} ${AppStrings.egp}",
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: AppStrings.paymentMethod,
            value: order.paymentType.isNotEmpty
                ? order.paymentType
                : AppStrings.cash,
          ),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            _InfoRow(
              label: AppStrings.products,
              value: order.items.length.toString(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFontStyle.regular13(
            context: context,
          ).copyWith(color: AppColors.gray7D),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppFontStyle.medium14(context: context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.state});

  final String state;

  Color get _color {
    switch (state.toLowerCase()) {
      case "completed":
      case "delivered":
        return AppColors.green0C;
      case "cancelled":
      case "canceled":
        return AppColors.redCC;
      default:
        return AppColors.primerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        state,
        style: AppFontStyle.medium12(context: context).copyWith(color: _color),
      ),
    );
  }
}
