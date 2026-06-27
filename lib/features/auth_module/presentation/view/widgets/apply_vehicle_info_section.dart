import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class ApplyVehicleInfoSection extends StatelessWidget {
  final TextEditingController vehicleNumberController;
  final VoidCallback onVehicleLicenseTapped;

  const ApplyVehicleInfoSection({
    super.key,
    required this.vehicleNumberController,
    required this.onVehicleLicenseTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthModuleCubit, AuthModuleState>(
      buildWhen: (previous, current) =>
          previous.vehiclesState != current.vehiclesState ||
          previous.selectedVehicle != current.selectedVehicle ||
          previous.vehicleLicense != current.vehicleLicense,
      builder: (context, state) {
        final vehicles = state.vehiclesState.data?.vehicles ?? [];
        return Column(
          children: [
            // Vehicle Type
            DropdownButtonFormField<VehicleTypeModel>(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              isExpanded: true,
              value: state.selectedVehicle,
              decoration: const InputDecoration(
                labelText: AppStrings.vehicleType,
                border: OutlineInputBorder(),
              ),
              items: vehicles.map((vehicle) {
                return DropdownMenuItem<VehicleTypeModel>(
                  value: vehicle,
                  child: Text(
                    vehicle.type ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  context.read<AuthModuleCubit>().doIndented(
                    ChangeVehicleEvent(val),
                  );
                }
              },
              validator: (v) => v == null ? AppStrings.requiredField : null,
            ),
            const Gap(16),

            // Vehicle number
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              controller: vehicleNumberController,
              decoration: const InputDecoration(
                labelText: AppStrings.vehicleNumber,
                hintText: AppStrings.enterVehicleNumber,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? AppStrings.requiredField : null,
            ),
            const Gap(16),

            // Vehicle license file picker
            InkWell(
              onTap: onVehicleLicenseTapped,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: AppStrings.vehicleLicense,
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        state.vehicleLicense != null
                            ? state.vehicleLicense!.path.split('/').last
                            : AppStrings.uploadLicensePhoto,
                        style: TextStyle(
                          color: state.vehicleLicense != null
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
