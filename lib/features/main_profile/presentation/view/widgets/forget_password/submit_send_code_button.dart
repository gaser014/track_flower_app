import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class SubmitSendCodeButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const SubmitSendCodeButton({
    required this.formKey,
    required this.emailController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (prev, curr) => prev.sendCodeState != curr.sendCodeState,
      builder: (context, state) {
        return ListenableBuilder(
          listenable: emailController,
          builder: (context, _) {
            final isEnabled = emailController.text.trim().isNotEmpty;
            return CustomButton(
              text: AppStrings.confirmForgetPassword,
              isLoading: state.sendCodeState.isLoading,
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
            SendCodeEvent(
              params: ForgetPasswordParams(
                email: emailController.text.trim(),
              ),
            ),
          );
    }
  }
}
