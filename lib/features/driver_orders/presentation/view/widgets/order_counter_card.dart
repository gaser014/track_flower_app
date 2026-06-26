import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class OrderCounterCard extends StatelessWidget {
  const OrderCounterCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  final int count;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pinkF9,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count.toString(),
            style: AppFontStyle.medium18(context: context),
          ),
          const Gap(8),
          Row(
            children: [
              Icon(icon, size: 24, color: color),
              const Gap(4),
              Text(
                label,
                style: AppFontStyle.medium16(context: context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
