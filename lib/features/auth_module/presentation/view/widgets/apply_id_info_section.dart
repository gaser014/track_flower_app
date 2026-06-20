import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';

class ApplyIdInfoSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController nidController;
  final VoidCallback onNidImageTapped;

  const ApplyIdInfoSection({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.nidController,
    required this.onNidImageTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (previous, current) => previous.nidImage != current.nidImage,
      builder: (context, state) {
        return Column(
          children: [
            // Email
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: AppStrings.email,
                hintText: AppStrings.enterEmail,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),

            // Phone Number
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: AppStrings.phoneNumber,
                hintText: AppStrings.enterPhoneNumber,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),

            // ID number
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: nidController,
              decoration: const InputDecoration(
                labelText: AppStrings.idNumber,
                hintText: AppStrings.enterIdNumber,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),

            // ID image file picker
            InkWell(
              onTap: onNidImageTapped,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: AppStrings.idImage,
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        state.nidImage != null
                            ? state.nidImage!.path.split('/').last
                            : AppStrings.uploadIdImage,
                        style: TextStyle(
                          color: state.nidImage != null
                              ? AppColors.black
                              : AppColors.gray7D,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.attach_file, color: AppColors.gray7D),
                  ],
                ),
              ),
            ),
            const Gap(16),
          ],
        );
      },
    );
  }
}
