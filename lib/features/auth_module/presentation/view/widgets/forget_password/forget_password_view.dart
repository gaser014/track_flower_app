import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_app_bar.dart';

import 'reset_password_body.dart';
import 'send_code_body.dart';
import 'verify_code_body.dart';

class ForgetPasswordView extends StatelessWidget {
  final PageController pageController;
  final TextEditingController emailController;
  final TextEditingController otpController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> sendCodeFormKey;
  final GlobalKey<FormState> verifyCodeFormKey;
  final GlobalKey<FormState> resetPasswordFormKey;
  final void Function(int page) goToPage;

  const ForgetPasswordView({
    required this.pageController,
    required this.emailController,
    required this.otpController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.sendCodeFormKey,
    required this.verifyCodeFormKey,
    required this.resetPasswordFormKey,
    required this.goToPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.password,
        onBackPressed: () {
          final page = pageController.hasClients
              ? (pageController.page ?? 0).toInt()
              : 0;
          if (page > 0) {
            goToPage(page - 1);
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SendCodeBody(
              formKey: sendCodeFormKey,
              emailController: emailController,
            ),
            VerifyCodeBody(
              formKey: verifyCodeFormKey,
              otpController: otpController,
              emailController: emailController,
            ),
            ResetPasswordBody(
              formKey: resetPasswordFormKey,
              emailController: emailController,
              newPasswordController: newPasswordController,
              confirmPasswordController: confirmPasswordController,
            ),
          ],
        ),
      ),
    );
  }
}
