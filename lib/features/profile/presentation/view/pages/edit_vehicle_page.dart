import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';

class EditVehiclePage extends StatefulWidget {
  const EditVehiclePage({super.key});

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController(text: 'UP16DL0007');
  final _vehicleLicenseController = TextEditingController();
  String _selectedVehicleType = 'Bike';
  File? _selectedImage;

  final List<String> _vehicleTypes = ['Bike', 'Car', 'Truck', 'Van'];

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _vehicleLicenseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _vehicleLicenseController.text = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdownField(
                  label: 'Vehicle type',
                  value: _selectedVehicleType,
                  items: _vehicleTypes,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedVehicleType = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Vehicle number',
                  controller: _vehicleNumberController,
                ),
                const SizedBox(height: 16),
                _buildUploadField(
                  label: 'Vehicle license',
                  controller: _vehicleLicenseController,
                  onTap: _pickImage,
                ),
                const Spacer(),
                CustomButton(
                  text: 'Update',
                  backgroundColor: AppColors.gray7D, // As per UI, it seems disabled/greyed out initially
                  onPressed: () {
                    // TODO: Handle update vehicle info
                    context.pop();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Edit profile',
        style: AppFontStyle.bold20(context: context).copyWith(color: AppColors.black0C),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none, size: 28, color: AppColors.black),
            ),
            Positioned(
              top: 12,
              right: 18,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.primerColor,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFontStyle.regular12(context: context).copyWith(color: AppColors.gray7D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayEA),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayEA),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primerColor),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFontStyle.regular12(context: context).copyWith(color: AppColors.gray7D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayEA),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayEA),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primerColor),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: AppFontStyle.regular16(context: context)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildUploadField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppFontStyle.regular12(context: context).copyWith(color: AppColors.gray7D),
            hintText: 'Select a photo...',
            suffixIcon: const Icon(CupertinoIcons.arrow_up_doc, color: AppColors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grayEA),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grayEA),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primerColor),
            ),
          ),
        ),
      ),
    );
  }
}
