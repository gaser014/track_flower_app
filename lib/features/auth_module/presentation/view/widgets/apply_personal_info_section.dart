import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class ApplyPersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const ApplyPersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (previous, current) =>
          previous.countriesState != current.countriesState ||
          previous.selectedCountry != current.selectedCountry,
      builder: (context, state) {
        final countries = state.countriesState.data ?? [];
        return Column(
          children: [
            // Country Dropdown
            DropdownButtonFormField<CountryModel>(
              isExpanded: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              value: state.selectedCountry,
              decoration: const InputDecoration(
                labelText: AppStrings.country,
                border: OutlineInputBorder(),
              ),
              items: countries.map((country) {
                return DropdownMenuItem<CountryModel>(
                  value: country,
                  child: Text(
                    '${country.flag ?? ""} ${country.name ?? ""}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  context.read<AuthModuleCubit>().doIndented(
                    ChangeCountryEvent(val),
                  );
                }
              },
            ),
            const Gap(16),

            // First & Second Legal Name
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: AppStrings.firstLegalName,
                hintText: AppStrings.enterFirstLegalName,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: AppStrings.secondLegalName,
                hintText: AppStrings.enterSecondLegalName,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),
          ],
        );
      },
    );
  }
}
