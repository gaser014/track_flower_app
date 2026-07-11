import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/validations/validations.dart';
import 'package:track_flowers_app/core/values/input_formatters.dart';

class AuthModulePasswordField extends StatelessWidget {
  const AuthModulePasswordField({
    super.key,
    required this.passwordController,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  final TextEditingController passwordController;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: !isVisible,
      keyboardType: TextInputType.visiblePassword,
      obscuringCharacter: '★',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: AppInputFormatters.strongPassword,
      validator: Validations.validateLoginPassword,
      autofillHints: const [AutofillHints.password],
      style: !isVisible
          ? const TextStyle(letterSpacing: 2, color: AppColors.grayA6)
          : null,
      decoration: InputDecoration(
        labelText: AppStrings.password,
        hintText: AppStrings.passwordHint,
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
