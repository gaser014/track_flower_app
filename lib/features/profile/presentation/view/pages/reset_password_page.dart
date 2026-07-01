import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _invalidPasswordError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUpdatePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final request = ChangePasswordRequestModel(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      context.read<ProfileCubit>().doIndented(ChangePasswordEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listenWhen: (previous, current) =>
            previous.changePasswordState != current.changePasswordState,
        listener: (context, state) {
          if (state.changePasswordState.isSuccess) {
            CustomToast.showSuccess(
              context: context,
              message: 'Password updated successfully',
            );
            context.pop();
          } else if (state.changePasswordState.isError) {
            final errorMsg = state.changePasswordState.exception?.toString() ?? 'Failed to update password';
            // Simple logic to show red field if it's an invalid current password
            if (errorMsg.toLowerCase().contains('invalid') || errorMsg.toLowerCase().contains('password')) {
              setState(() {
                _invalidPasswordError = 'Invalid password';
              });
            } else {
              CustomToast.showError(
                context: context,
                message: errorMsg,
              );
            }
          }
        },
        builder: (context, state) {
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
                      const SizedBox(height: 24),
                      _buildPasswordField(
                        label: 'Current password',
                        controller: _currentPasswordController,
                        errorText: _invalidPasswordError,
                        onChanged: (val) {
                          if (_invalidPasswordError != null) {
                            setState(() {
                              _invalidPasswordError = null;
                            });
                          }
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        label: 'New password',
                        controller: _newPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter new password';
                          }
                          if (val.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        label: 'Confirm password',
                        controller: _confirmPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (val != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Update',
                        isLoading: state.changePasswordState.isLoading,
                        backgroundColor: AppColors.gray7D, // From design
                        onPressed: () => _onUpdatePressed(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
        'Reset password',
        style: AppFontStyle.bold20(context: context).copyWith(color: AppColors.black0C),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? errorText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: true,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppFontStyle.regular12(context: context).copyWith(
              color: hasError ? AppColors.redCC : AppColors.gray7D,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.redCC : AppColors.grayEA,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.redCC : AppColors.grayEA,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.redCC : AppColors.primerColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.redCC),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: AppFontStyle.regular12(context: context).copyWith(
                color: AppColors.redCC,
              ),
            ),
          ),
      ],
    );
  }
}
