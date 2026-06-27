import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_events.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_states.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';

class EditVehicleInfoPage extends StatefulWidget {
  const EditVehicleInfoPage({super.key});

  @override
  State<EditVehicleInfoPage> createState() => _EditVehicleInfoPageState();
}

class _EditVehicleInfoPageState extends State<EditVehicleInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _vehicleLicenseController = TextEditingController();
  String _vehicleType = 'Bike';
  File? _vehicleImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
        _vehicleLicenseController.text = pickedFile.name;
      });
    }
  }

  bool get _isFormValid {
    return _vehicleNumberController.text.trim().isNotEmpty &&
           _vehicleLicenseController.text.trim().isNotEmpty;
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _vehicleNumberController.addListener(_onFieldChanged);
    _vehicleLicenseController.addListener(_onFieldChanged);

    final cubit = getIt.get<ProfileCubit>();
    if (cubit.state.getProfileState.isSuccess) {
      final profile = cubit.state.getProfileState.data;
      if (profile?.vehicleType != null && ['Bike', 'Car', 'Truck', 'Van'].contains(profile!.vehicleType)) {
        _vehicleType = profile!.vehicleType!;
      }
      _vehicleNumberController.text = profile?.vehicleNumber ?? '';
      _vehicleLicenseController.text = profile?.vehicleLicense ?? '';
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _vehicleLicenseController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final body = {
        'vehicleType': _vehicleType,
        'vehicleNumber': _vehicleNumberController.text,
        'vehicleLicense': _vehicleLicenseController.text,
      };
      if (_vehicleImage != null) {
        body['vehicleImage'] = _vehicleImage!.path;
      }
      
      context.read<ProfileCubit>().doIndented(
        EditProfileEvent(body: body),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.grayA6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grayA6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grayA6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primerColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt.get<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Edit profile', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: false,
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: AppColors.black, size: 26),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.redCC,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('3', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
            const Gap(8),
          ],
        ),
        body: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {
            if (state.editProfileState.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehicle info updated successfully')),
              );
              Navigator.pop(context);
            } else if (state.editProfileState.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.editProfileState.exception.toString()}')),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Gap(16),
                    DropdownButtonFormField<String>(
                      initialValue: _vehicleType,
                      decoration: _inputDecoration('Vehicle type'),
                      items: ['Bike', 'Car', 'Truck', 'Van'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) {
                        setState(() => _vehicleType = val!);
                      },
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _vehicleNumberController,
                      decoration: _inputDecoration('Vehicle number'),
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _vehicleLicenseController,
                      readOnly: true,
                      onTap: _pickImage,
                      decoration: _inputDecoration('Vehicle license').copyWith(
                        suffixIcon: const Icon(Icons.file_upload_outlined, color: AppColors.black),
                      ),
                    ),
                    if (_vehicleImage != null) ...[
                      const Gap(16),
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grayA6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_vehicleImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                    const Gap(32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gray7D,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: (state.editProfileState.isLoading || !_isFormValid) ? null : () => _saveProfile(context),
                        child: state.editProfileState.isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) 
                            : const Text('Update', style: TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Gap(32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
