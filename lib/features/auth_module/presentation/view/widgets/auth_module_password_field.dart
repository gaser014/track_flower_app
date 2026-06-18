import 'package:track_flowers_app/core/widgets/text_field/password_field.dart';
import 'package:flutter/material.dart';

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
    return PasswordField(
      controller: passwordController,
      obscureText: !isVisible,
      suffixIcon: IconButton(
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: onToggleVisibility,
      ),
    );
  }
}
