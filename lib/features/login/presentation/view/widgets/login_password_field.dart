import 'package:track_flowers_app/core/widgets/text_field/password_field.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      buildWhen: (previous, current) =>
          previous.showPasswordState != current.showPasswordState,
      builder: (context, state) {
        return PasswordField(
          controller: passwordController,
          obscureText: state.showPasswordState.data ?? false,
          suffixIcon: IconButton(
            icon: Icon(
              (state.showPasswordState.data ?? false)
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              context.read<LoginCubit>().doIndented(
                ShowPasswordEvent(
                  showPassword: !(state.showPasswordState.data ?? false),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
