import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class SubmitResetPasswordButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const SubmitResetPasswordButton({
    required this.formKey,
    required this.emailController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (prev, curr) =>
          prev.resetPasswordState != curr.resetPasswordState,
      builder: (context, state) {
        return ListenableBuilder(
          listenable: Listenable.merge([
            newPasswordController,
            confirmPasswordController,
          ]),
          builder: (context, _) {
            final isEnabled =
                newPasswordController.text.isNotEmpty &&
                confirmPasswordController.text.isNotEmpty;
            return CustomButton(
              text: AppStrings.confirm,
              isLoading: state.resetPasswordState.isLoading,
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
        ResetPasswordEvent(
          params: ForgetPasswordParams(
            email: emailController.text.trim(),
            newPassword: newPasswordController.text,
          ),
        ),
      );
    }
  }
}
