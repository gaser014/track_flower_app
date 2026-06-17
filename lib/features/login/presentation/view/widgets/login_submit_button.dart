import 'dart:developer';

import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({
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
    return BlocConsumer<LoginCubit, LoginStates>(
      listenWhen: (previous, current) =>
          previous.loginState != current.loginState,
      listener: (context, state) {
        if (state.loginState.isSuccess) {
          context.go(Routes.main);
          CustomToast(
            context: context,
            message: AppStrings.loginSuccessfully,
          ).show();
        } else if (state.loginState.isError) {
          CustomToast(context: context, message: AppStrings.loginError).show();
        }
      },
      buildWhen: (previous, current) =>
          previous.loginState != current.loginState ||
          previous.rememberMeState != current.rememberMeState,
      builder: (context, state) {
        return CustomButton(
          text: AppStrings.loginTitle,
          isLoading: state.loginState.isLoading,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              context.read<LoginCubit>().doIndented(
                LoginEvent(
                  params: LoginParams(
                    email: emailController.text,
                    password: passwordController.text,
                    remember: state.rememberMeState.data ?? false,
                  ),
                ),
              );
              log("++++++++++++${state.rememberMeState.data}");
            }
          },
        );
      },
    );
  }
}
