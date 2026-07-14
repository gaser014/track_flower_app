import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class AuthModuleRememberMeRow extends StatelessWidget {
  const AuthModuleRememberMeRow({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTapped,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPasswordTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) => onRememberMeChanged(value ?? false),
        ),
        Text(AppStrings.rememberMe),
        const Spacer(),
        TextButton(
          onPressed: onForgotPasswordTapped,
          child: Text(AppStrings.forgotPassword),
        ),
      ],
    );
  }
}
