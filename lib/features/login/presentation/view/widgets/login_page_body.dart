import 'package:track_flowers_app/features/login/presentation/view/widgets/dont_have_account_section.dart';
import 'package:track_flowers_app/features/login/presentation/view/widgets/login_form_section.dart';
import 'package:flutter/material.dart';

class LoginPageBody extends StatelessWidget {
  const LoginPageBody({
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            LoginFormSection(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
            ),
            const DontHaveAccountSection(),
          ],
        ),
      ),
    );
  }
}
