import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';

class ApplyPasswordSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController rePasswordController;

  const ApplyPasswordSection({
    super.key,
    required this.passwordController,
    required this.rePasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,

                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.password,
                  hintText: AppStrings.enterPassword,
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.requiredField : null,
              ),
            ),
            const Gap(16),
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,

                controller: rePasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.confirmPasswordTitle,
                  hintText: AppStrings.confirmPasswordHint,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return AppStrings.requiredField;
                  if (v != passwordController.text) {
                    return AppStrings.mismatchError;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const Gap(24),
      ],
    );
  }
}
