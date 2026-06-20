import 'package:track_flowers_app/core/widgets/text_field/email_field.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/auth_module_password_field.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/auth_module_submit_button.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/auth_module_remember_me_row.dart';
import 'package:flutter/material.dart';

class AuthModuleFormSection extends StatelessWidget {
  const AuthModuleFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTapped,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  // state values
  final bool isPasswordVisible;
  final bool rememberMe;
  final bool isLoading;

  // callbacks
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPasswordTapped;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          EmailField(controller: emailController),
          AuthModulePasswordField(
            passwordController: passwordController,
            isVisible: isPasswordVisible,
            onToggleVisibility: onTogglePasswordVisibility,
          ),
          AuthModuleRememberMeRow(
            rememberMe: rememberMe,
            onRememberMeChanged: onRememberMeChanged,
            onForgotPasswordTapped: onForgotPasswordTapped,
          ),
          const SizedBox(height: 32),
          AuthModuleSubmitButton(isLoading: isLoading, onPressed: onSubmit),
        ],
      ),
    );
  }
}
