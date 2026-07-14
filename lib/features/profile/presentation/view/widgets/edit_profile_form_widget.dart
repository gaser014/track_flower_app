import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/core/widgets/text_field/email_field.dart';
import 'package:track_flowers_app/core/widgets/text_field/phone_field.dart';
import 'package:track_flowers_app/core/widgets/text_field/user_name_field.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:track_flowers_app/features/profile/presentation/view/widgets/gender_selector_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/core/routes/routes.dart';

class EditProfileFormWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onUpdate;
  final bool isLoading;

  const EditProfileFormWidget({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.onUpdate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: UserNameField(
                    controller: firstNameController,
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                    validator: (val) {
                       if (val == null || val.isEmpty) return 'First name is required';
                       return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: UserNameField(
                    controller: lastNameController,
                    labelText: 'Last Name',
                    hintText: 'Enter last name',
                    validator: (val) {
                       if (val == null || val.isEmpty) return 'Last name is required';
                       return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            EmailField(
              controller: emailController,
              enabled: false, // Email is typically read-only in edit profile
            ),
            const SizedBox(height: 16),
            PhoneField(
              controller: phoneController,
            ),
            const SizedBox(height: 16),
            _buildPasswordMockField(context),
            const SizedBox(height: 24),
            GenderSelectorWidget(
              selectedGender: state.selectedGender,
              onGenderChanged: (gender) {
                context.read<ProfileCubit>().doIndented(ToggleGenderEvent(gender));
              },
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Update',
              isLoading: isLoading,
              onPressed: onUpdate,
              backgroundColor: AppColors.gray7D,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordMockField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayA6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '********',
              style: TextStyle(letterSpacing: 4, color: AppColors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push(Routes.changePassword);
            },
            child: Text(
              'Change',
              style: AppFontStyle.medium14(context: context)
                  .copyWith(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
