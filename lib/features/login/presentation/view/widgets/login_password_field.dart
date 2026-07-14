import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/validations/validations.dart';
import 'package:track_flowers_app/core/values/input_formatters.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      buildWhen: (previous, current) =>
          previous.showPasswordState != current.showPasswordState,
      builder: (context, state) {
        final isVisible = state.showPasswordState.data ?? false;
        return TextFormField(
          controller: passwordController,
          obscureText: !isVisible,
          keyboardType: TextInputType.visiblePassword,
          obscuringCharacter: '★',
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: AppInputFormatters.strongPassword,
          validator: Validations.validateLoginPassword,
          autofillHints: const [AutofillHints.password],
          style: !isVisible
              ? const TextStyle(letterSpacing: 2, color: AppColors.grayA6)
              : null,
          decoration: InputDecoration(
            labelText: AppStrings.password,
            hintText: AppStrings.passwordHint,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                context.read<LoginCubit>().doIndented(
                  ShowPasswordEvent(
                    showPassword: !isVisible,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
