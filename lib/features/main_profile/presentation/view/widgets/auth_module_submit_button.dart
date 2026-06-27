import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AuthModuleSubmitButton extends StatelessWidget {
  const AuthModuleSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: AppStrings.continueButton,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
