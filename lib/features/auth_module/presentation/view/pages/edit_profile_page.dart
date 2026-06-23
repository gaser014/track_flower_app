import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_states.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/change_password_page.dart';
import 'package:gap/gap.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController(text: '123456');
  String _gender = 'Male';

  bool get _isFormValid {
    return _firstNameController.text.trim().isNotEmpty &&
           _lastNameController.text.trim().isNotEmpty &&
           _emailController.text.trim().isNotEmpty &&
           _phoneController.text.trim().isNotEmpty &&
           _passwordController.text.trim().isNotEmpty;
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);

    final cubit = getIt.get<AuthModuleCubit>();
    if (cubit.state.getProfileState.isSuccess) {
      final profile = cubit.state.getProfileState.data;
      _firstNameController.text = profile?.firstName ?? '';
      _lastNameController.text = profile?.lastName ?? '';
      _emailController.text = profile?.email ?? '';
      _phoneController.text = profile?.phone ?? '';
      if (profile?.gender != null) _gender = profile!.gender!;
    }

    // Trigger rebuild after setting controller texts so _isFormValid reflects actual values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// استخراج رسالة خطأ مقروءة من الـ exception
  String _extractErrorMessage(Exception? exception) {
    if (exception == null) return 'Something went wrong. Please try again.';
    final raw = exception.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.replaceFirst('Exception: ', '');
    }
    return raw;
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthModuleCubit>().doIndented(
        EditProfileEvent(body: {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'gender': _gender,
        }),
      );
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final digitsOnly = value.trim().replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD32F2F)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
      ),
      errorStyle: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt.get<AuthModuleCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit profile',
            style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
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
                    child: const Text(
                      '3',
                      style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            const Gap(8),
          ],
        ),
        body: BlocConsumer<AuthModuleCubit, AuthModuleStates>(
          listener: (context, state) {
            if (state.editProfileState.isSuccess) {
              _showSuccessSnackBar(context, 'Profile updated successfully');
              Navigator.pop(context);
            } else if (state.editProfileState.isError) {
              final message = _extractErrorMessage(state.editProfileState.exception);
              _showErrorSnackBar(context, message);
            }
          },
          builder: (context, state) {
            final isEnabled = !state.editProfileState.isLoading && _isFormValid;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.grayEA,
                            child: Icon(Icons.person, size: 40, color: AppColors.gray7D),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.pinkF9,
                                border: Border.all(color: AppColors.white, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 14, color: AppColors.primerColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(32),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: _inputDecoration('First name'),
                            validator: (v) => _validateRequired(v, 'First name'),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: _inputDecoration('Last name'),
                            validator: (v) => _validateRequired(v, 'Last name'),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      textInputAction: TextInputAction.next,
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration('Phone number'),
                      validator: _validatePhone,
                      textInputAction: TextInputAction.next,
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration('Password').copyWith(
                        suffixIcon: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                            );
                          },
                          child: const Text(
                            'Change',
                            style: TextStyle(color: AppColors.black32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Gap(24),
                        // ignore: deprecated_member_use
                        Radio<String>(
                          value: 'Female',
                          // ignore: deprecated_member_use
                          groupValue: _gender,
                          activeColor: AppColors.primerColor,
                          // ignore: deprecated_member_use
                          onChanged: (val) => setState(() => _gender = val!),
                        ),
                        const Text('Female'),
                        const Gap(8),
                        // ignore: deprecated_member_use
                        Radio<String>(
                          value: 'Male',
                          // ignore: deprecated_member_use
                          groupValue: _gender,
                          activeColor: AppColors.primerColor,
                          // ignore: deprecated_member_use
                          onChanged: (val) => setState(() => _gender = val!),
                        ),
                        const Text('Male'),
                      ],
                    ),
                    const Gap(32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEnabled ? AppColors.primerColor : AppColors.gray7D,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: state.editProfileState.isLoading ? null : () => _saveProfile(context),
                        child: state.editProfileState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
                              ),
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
