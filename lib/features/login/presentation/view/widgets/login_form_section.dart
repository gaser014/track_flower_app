import 'package:track_flowers_app/core/widgets/text_field/email_field.dart';
import 'package:track_flowers_app/features/login/presentation/view/widgets/guest_login_button.dart';
import 'package:track_flowers_app/features/login/presentation/view/widgets/login_password_field.dart';
import 'package:track_flowers_app/features/login/presentation/view/widgets/login_submit_button.dart';
import 'package:track_flowers_app/features/login/presentation/view/widgets/remember_me_and_forgot_password_row.dart';
import 'package:flutter/material.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          EmailField(controller: emailController),
          LoginPasswordField(passwordController: passwordController),
          const RememberMeAndForgotPasswordRow(),
          const SizedBox(height: 32),
          LoginSubmitButton(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
          const GuestLoginButton(),
        ],
      ),
    );
  }
}
