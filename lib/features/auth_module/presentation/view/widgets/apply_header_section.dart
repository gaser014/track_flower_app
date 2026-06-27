import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';

class ApplyHeaderSection extends StatelessWidget {
  const ApplyHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeExclamation,
          style: AppFontStyle.bold24(context: context),
        ),
        const Gap(8),
        Text(
          AppStrings.joinOurTeam,
          style: AppFontStyle.medium16(
            context: context,
          ).copyWith(color: AppColors.gray7D),
        ),
        const Gap(24),
      ],
    );
  }
}
