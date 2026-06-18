import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingActionButtons extends StatelessWidget {
  const OnboardingActionButtons({
    super.key,
    required this.onLoginTapped,
    required this.onApplyTapped,
  });

  final VoidCallback onLoginTapped;
  final VoidCallback onApplyTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(text: AppStrings.loginTitle, onPressed: onLoginTapped),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Apply now',
          variant: ButtonVariant.outlined,
          onPressed: onApplyTapped,
        ),
        const SizedBox(height: 16),
        Text(
          'v 8.1.0 · 1449',
          style: AppFontStyle.regular12(
            context: context,
          ).copyWith(color: AppColors.grayA6),
        ),
      ],
    );
  }
}
