import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class SubmitVerifyCodeButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController otpController;

  const SubmitVerifyCodeButton({
    required this.formKey,
    required this.otpController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (prev, curr) => prev.verifyCodeState != curr.verifyCodeState,
      builder: (context, state) {
        return ListenableBuilder(
          listenable: otpController,
          builder: (context, _) {
            final isEnabled = otpController.text.trim().length == 4;
            return CustomButton(
              text: AppStrings.confirm,
              isLoading: state.verifyCodeState.isLoading,
              isEnabled: isEnabled,
              onPressed: isEnabled ? () => _submit(context) : null,
            );
          },
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
