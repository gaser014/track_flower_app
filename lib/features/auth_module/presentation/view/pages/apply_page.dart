import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

class ApplyPage extends StatelessWidget {
  const ApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuthModuleCubit>()..doIndented(GetInitialDataEvent()),
      child: const _ApplyPageBody(),
    );
  }
}

class _ApplyPageBody extends StatefulWidget {
  const _ApplyPageBody();

  @override
  State<_ApplyPageBody> createState() => _ApplyPageBodyState();
}

class _ApplyPageBodyState extends State<_ApplyPageBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _nidController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showImagePickerModal(BuildContext context, bool isVehicle) {
    final cubit = context.read<AuthModuleCubit>();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxWidth: 800,
                  );
                  if (pickedFile != null) {
                    if (isVehicle) {
                      cubit.doIndented(
                        PickVehicleLicenseEvent(File(pickedFile.path)),
                      );
                    } else {
                      cubit.doIndented(
                        PickNidImageEvent(File(pickedFile.path)),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                    maxWidth: 800,
                  );
                  if (pickedFile != null) {
                    if (isVehicle) {
                      cubit.doIndented(
                        PickVehicleLicenseEvent(File(pickedFile.path)),
                      );
                    } else {
                      cubit.doIndented(
                        PickNidImageEvent(File(pickedFile.path)),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitApplication(BuildContext context, AuthModuleState state) {
    if (!_formKey.currentState!.validate()) return;

    if (state.vehicleLicense == null) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: const Text("Please upload vehicle license"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (state.nidImage == null) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: const Text("Please upload national ID image"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: const Text("Passwords do not match"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final params = ApplyDriverParams(
      country: state.selectedCountry?.name ?? 'Egypt',
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      vehicleType: state.selectedVehicle?.id ?? '',
      vehicleNumber: _vehicleNumberController.text,
      vehicleLicense: state.vehicleLicense!,
      nid: _nidController.text,
      nidImg: state.nidImage!,
      email: _emailController.text,
      password: _passwordController.text,
      rePassword: _rePasswordController.text,
      gender: state.gender,
      phone: _phoneController.text,
    );

    context.read<AuthModuleCubit>().doIndented(ApplyDriverEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply'), centerTitle: false),
      body: BlocConsumer<AuthModuleCubit, AuthModuleState>(
        listenWhen: (previous, current) =>
            previous.applyDriverState != current.applyDriverState,
        listener: (context, state) {
          state.applyDriverState.when(
            initial: () {},
            loading: () {},
            success: (data) {
              toastification.show(
                context: context,
                title: const Text("Success"),
                description: Text(
                  data.message ?? "Application submitted successfully!",
                ),
                type: ToastificationType.success,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            error: (exception) {
              toastification.show(
                context: context,
                title: const Text("Error"),
                description: Text(exception.toString()),
                type: ToastificationType.error,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
          );
        },
        builder: (context, state) {
          if (state.countriesState.isLoading || state.vehiclesState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final countries = state.countriesState.data ?? [];
          final vehicles = state.vehiclesState.data?.vehicles ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!!',
                    style: AppFontStyle.bold24(context: context),
                  ),
                  const Gap(8),
                  Text(
                    'You want to be a delivery man?\nJoin our team',
                    style: AppFontStyle.medium16(
                      context: context,
                    ).copyWith(color: AppColors.gray7D),
                  ),
                  const Gap(24),

                  // Country Dropdown
                  DropdownButtonFormField<CountryModel>(
                    initialValue: state.selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                    items: countries.map((country) {
                      return DropdownMenuItem<CountryModel>(
                        value: country,
                        child: Text(
                          '${country.flag ?? ""} ${country.name ?? ""}',
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
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First legal name',
                      hintText: 'Enter first legal name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Second legal name',
                      hintText: 'Enter second legal name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),

                  // Vehicle Type
                  DropdownButtonFormField<VehicleTypeModel>(
                    initialValue: state.selectedVehicle,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle type',
                      border: OutlineInputBorder(),
                    ),
                    items: vehicles.map((vehicle) {
                      return DropdownMenuItem<VehicleTypeModel>(
                        value: vehicle,
                        child: Text(vehicle.type ?? ""),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<AuthModuleCubit>().doIndented(
                          ChangeVehicleEvent(val),
                        );
                      }
                    },
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const Gap(16),

                  // Vehicle number
                  TextFormField(
                    controller: _vehicleNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle number',
                      hintText: 'Enter vehicle number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),

                  // Vehicle license file picker
                  InkWell(
                    onTap: () => _showImagePickerModal(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Vehicle license',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.vehicleLicense != null
                                  ? state.vehicleLicense!.path.split('/').last
                                  : 'Upload license photo',
                              style: TextStyle(
                                color: state.vehicleLicense != null
                                    ? AppColors.black
                                    : AppColors.grayA6,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.upload_outlined),
                        ],
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter you email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      hintText: 'Enter phone number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),

                  // ID number
                  TextFormField(
                    controller: _nidController,
                    decoration: const InputDecoration(
                      labelText: 'ID number',
                      hintText: 'Enter national ID number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const Gap(16),

                  // ID image file picker
                  InkWell(
                    onTap: () => _showImagePickerModal(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'ID image',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.nidImage != null
                                  ? state.nidImage!.path.split('/').last
                                  : 'Upload ID image',
                              style: TextStyle(
                                color: state.nidImage != null
                                    ? AppColors.black
                                    : AppColors.grayA6,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.upload_outlined),
                        ],
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Passwords
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: TextFormField(
                          controller: _rePasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm password',
                            hintText: 'Confirm password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v != _passwordController.text)
                              return 'Mismatch';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Gender Radio
                  Row(
                    children: [
                      Text(
                        'Gender',
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
                      const Text('Femail'),
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
                      const Text('Male'),
                    ],
                  ),
                  const Gap(32),

                  // Submit Button
                  CustomButton(
                    text: 'Continue',
                    isLoading: state.applyDriverState.isLoading,
                    onPressed: () => _submitApplication(context, state),
                  ),
                  const Gap(32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
