import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class OrderPillButton extends StatelessWidget {
  const OrderPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.expanded = false,
    this.height = 36,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool expanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final background = filled
        ? (enabled ? AppColors.primerColor : AppColors.grayA6)
        : AppColors.whiteF9;
    final foreground = filled ? AppColors.whiteF9 : AppColors.primerColor;

    final button = SizedBox(
      height: height,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: filled
              ? BorderSide.none
              : const BorderSide(color: AppColors.primerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              widthFactor: expanded ? null : 1,
              child: Text(
                label,
                style: AppFontStyle.medium14(
                  context: context,
                ).copyWith(color: foreground, letterSpacing: 0.1),
              ),
            ),
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
