import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/text_field/email_field.dart';

import 'forget_password_header.dart';
import 'submit_send_code_button.dart';

class SendCodeBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const SendCodeBody({
    required this.formKey,
    required this.emailController,
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
            title: AppStrings.forgetPasswordTitle,
            subtitle: AppStrings.forgetPasswordSubtitle,
          ),
          Gap(32.h),
          EmailField(controller: emailController),
          Gap(32.h),
          SubmitSendCodeButton(
            formKey: formKey,
            emailController: emailController,
          ),
        ],
      ),
    );
  }
}

