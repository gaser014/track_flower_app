import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class ApplyGenderSection extends StatelessWidget {
  const ApplyGenderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  AppStrings.genderLabel,
                  style: AppFontStyle.semiBold16(
                    context: context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(24),
                Radio<String>(
                  value: 'female',
                  groupValue: state.gender,
                  activeColor: AppColors.primerColor,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<AuthModuleCubit>().doIndented(
                        ChangeGenderEvent(val),
                      );
                    }
                  },
                ),
                const Text(AppStrings.femailLabel),
                const Gap(16),
                Radio<String>(
                  value: 'male',
                  groupValue: state.gender,
                  activeColor: AppColors.primerColor,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<AuthModuleCubit>().doIndented(
                        ChangeGenderEvent(val),
                      );
                    }
                  },
                ),
                const Text(AppStrings.maleLabel),
              ],
            ),
            const Gap(32),
          ],
        );
      },
    );
  }
}
