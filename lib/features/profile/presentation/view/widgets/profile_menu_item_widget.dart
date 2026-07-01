import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData? icon;
  final Widget? leadingIconWidget;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileMenuItemWidget({
    super.key,
    this.icon,
    this.leadingIconWidget,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            if (leadingIconWidget != null) ...[
              leadingIconWidget!,
              const SizedBox(width: 16),
            ] else if (icon != null) ...[
              Icon(icon, size: 24, color: AppColors.black),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: AppFontStyle.regular16(context: context),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(Icons.chevron_right, color: AppColors.gray7D),
          ],
        ),
      ),
    );
  }
}
