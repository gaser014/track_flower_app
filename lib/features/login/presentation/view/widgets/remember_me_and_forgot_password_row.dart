import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RememberMeAndForgotPasswordRow extends StatelessWidget {
  const RememberMeAndForgotPasswordRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<LoginCubit, LoginStates>(
          buildWhen: (previous, current) =>
              previous.rememberMeState != current.rememberMeState,
          builder: (context, state) {
            return Checkbox(
              value: state.rememberMeState.data ?? false,
              onChanged: (value) {
                context.read<LoginCubit>().doIndented(
                  RememberMeEvent(rememberMe: value ?? false),
                );
              },
            );
          },
        ),
        Text(AppStrings.rememberMe),
        Spacer(),
        TextButton(
          onPressed: () => context.push(Routes.forgetPassword),
          child: Text(AppStrings.forgotPassword),
        ),
      ],
    );
  }
}
