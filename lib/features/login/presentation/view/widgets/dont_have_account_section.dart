import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccountSection extends StatelessWidget {
  const DontHaveAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.noAccount),
        TextButton(
          onPressed: () => context.push(Routes.register),
          child: Text(AppStrings.signUp),
        ),
      ],
    );
  }
}
