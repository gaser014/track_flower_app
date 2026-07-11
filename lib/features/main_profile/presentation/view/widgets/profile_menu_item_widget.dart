import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final IconData? icon;
  final Widget? leadingIconWidget;

  const ProfileMenuItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.trailing,
    this.icon,
    this.leadingIconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Row(
          children: [
            if (leadingIconWidget case final leading?) ...[
              leading,
              const Gap(16),
            ] else if (icon case final ic?) ...[
              Icon(ic, color: AppColors.black32, size: 24),
              const Gap(16),
            ],
            Expanded(
              child: Text(
                title,
                style: AppFontStyle.regular16(
                  context: context,
                ).copyWith(color: AppColors.black32),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
