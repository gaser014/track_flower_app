import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      backgroundColor: AppColors.transparent,
      textColor: AppColors.gray53,
      text: AppStrings.continueAsGuest,
      borderSide: const BorderSide(color: AppColors.gray53, width: 1),
      onPressed: () {},
    );
  }
}
