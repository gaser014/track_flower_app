import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/text_field/password_field.dart';

import 'forget_password_header.dart';
import 'submit_reset_password_button.dart';

class ResetPasswordBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ResetPasswordBody({
    required this.formKey,
    required this.emailController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ForgetPasswordHeader(
            title: AppStrings.resetPasswordTitle,
            subtitle: AppStrings.resetPasswordSubtitle,
          ),
          Gap(32.h),
          _PasswordFields(
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
          ),
          Gap(32.h),
          SubmitResetPasswordButton(
            formKey: formKey,
            emailController: emailController,
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
          ),
        ],
      ),
    );
  }
}

class _PasswordFields extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const _PasswordFields({
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordField(
          controller: newPasswordController,
          labelText: AppStrings.newPassword,
        ),
        Gap(16.h),
        PasswordField(
          controller: confirmPasswordController,
          labelText: AppStrings.confirmNewPassword,
          validator: (value) {
            if (value != newPasswordController.text) {
              return AppStrings.confirmPasswordMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }
}

