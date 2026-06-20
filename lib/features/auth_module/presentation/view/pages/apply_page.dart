import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';

import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';

import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_header_section.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_personal_info_section.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_vehicle_info_section.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_id_info_section.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_password_section.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/apply_gender_section.dart';
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
                title: const Text(AppStrings.photoLibrary),
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
                title: const Text(AppStrings.camera),
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
        title: const Text(AppStrings.error),
        description: const Text(AppStrings.uploadVehicleLicenseError),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (state.nidImage == null) {
      toastification.show(
        context: context,
        title: const Text(AppStrings.error),
        description: const Text(AppStrings.uploadNidImageError),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      toastification.show(
        context: context,
        title: const Text(AppStrings.error),
        description: const Text(AppStrings.confirmPasswordInvalid),
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
      appBar: AppBar(title: const Text(AppStrings.apply), centerTitle: false),
      body: BlocConsumer<AuthModuleCubit, AuthModuleState>(
        listenWhen: (previous, current) =>
            previous.applyDriverState != current.applyDriverState,
        listener: (context, state) {
          state.applyDriverState.when(
            initial: () {},
            loading: () {},
            success: (data) {
              context.go(Routes.applySuccess);
              toastification.show(
                context: context,
                title: const Text(AppStrings.success),
                description: Text(
                  data.message ?? AppStrings.applicationSubmittedSuccess,
                ),
                type: ToastificationType.success,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            error: (exception) {
              toastification.show(
                context: context,
                title: const Text(AppStrings.error),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ApplyHeaderSection(),
                  ApplyPersonalInfoSection(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                  ),
                  ApplyVehicleInfoSection(
                    vehicleNumberController: _vehicleNumberController,
                    onVehicleLicenseTapped: () =>
                        _showImagePickerModal(context, true),
                  ),
                  ApplyIdInfoSection(
                    emailController: _emailController,
                    phoneController: _phoneController,
                    nidController: _nidController,
                    onNidImageTapped: () =>
                        _showImagePickerModal(context, false),
                  ),
                  ApplyPasswordSection(
                    passwordController: _passwordController,
                    rePasswordController: _rePasswordController,
                  ),
                  const ApplyGenderSection(),
                  const Gap(32),

                  // Submit Button
                  CustomButton(
                    text: AppStrings.continueButton,
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
