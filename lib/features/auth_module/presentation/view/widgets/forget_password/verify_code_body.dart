import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/resend_timer_widget.dart';
import 'package:track_flowers_app/core/widgets/text_field/otp_input_field.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

import 'forget_password_header.dart';
import 'submit_verify_code_button.dart';

class VerifyCodeBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController otpController;
  final TextEditingController emailController;

  const VerifyCodeBody({
    required this.formKey,
    required this.otpController,
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
            title: AppStrings.verificationCodeTitle,
            subtitle: AppStrings.verificationCodeSubtitle,
          ),
          Gap(32.h),
          _OtpSection(otpController: otpController, formKey: formKey),
          Gap(16.h),
          _ResendCodeSection(emailController: emailController),
          Gap(32.h),
          SubmitVerifyCodeButton(
            formKey: formKey,
            otpController: otpController,
          ),
        ],
      ),
    );
  }
}

class _OtpSection extends StatelessWidget {
  final TextEditingController otpController;
  final GlobalKey<FormState> formKey;

  const _OtpSection({
    required this.otpController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (prev, curr) => prev.verifyCodeState != curr.verifyCodeState,
      builder: (context, state) {
        return Column(
          children: [
            OtpInputField(
              controller: otpController,
              length: 4,
              hasError: state.verifyCodeState.isError,
              onCompleted: (_) => _submit(context),
            ),
            if (state.verifyCodeState.isError) ...[
              Gap(8.h),
              Text(
                state.verifyCodeState.exception?.toString() ??
                    AppStrings.somethingWentWrong,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthModuleCubit>().doIndented(
            VerifyCodeEvent(
              params: ForgetPasswordParams(
                resetCode: otpController.text.trim(),
              ),
            ),
          );
    }
  }
}

class _ResendCodeSection extends StatelessWidget {
  final TextEditingController emailController;

  const _ResendCodeSection({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return ResendTimerWidget(
      onResend: () => context.read<AuthModuleCubit>().doIndented(
            SendCodeEvent(
              params: ForgetPasswordParams(
                email: emailController.text.trim(),
              ),
            ),
          ),
    );
  }
}

