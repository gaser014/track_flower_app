import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_app_bar.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:track_flowers_app/features/profile/presentation/view/widgets/edit_profile_form_widget.dart';
import 'package:track_flowers_app/features/profile/presentation/view/widgets/edit_profile_photo_widget.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt.get<ProfileCubit>(), // Reuse existing cubit or create new one if needed
      child: Scaffold(
        appBar: const CustomAppBar(
          title: AppStrings.editProfile,
          showBackButton: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileStates>(
          listenWhen: (previous, current) =>
              previous.editProfileState != current.editProfileState ||
              previous.uploadPhotoState != current.uploadPhotoState,
          listener: (context, state) {
            if (state.editProfileState.isSuccess) {
              CustomToast.showSuccess(
                  context: context, message: "Profile updated successfully");
              context.pop();
            } else if (state.editProfileState.isError) {
              CustomToast.showError(
                  context: context,
                  message: state.editProfileState.exception.toString());
            }

            if (state.uploadPhotoState.isError) {
              CustomToast.showError(
                  context: context,
                  message: state.uploadPhotoState.exception.toString());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditProfilePhotoWidget(
                      networkPhotoUrl: widget.user.photo,
                      localPhotoPath: state.localPhotoPath,
                      onPhotoSelected: (file) {
                        context
                            .read<ProfileCubit>()
                            .doIndented(UploadProfilePhotoEvent(file));
                      },
                    ),
                    const SizedBox(height: 32),
                    EditProfileFormWidget(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      isLoading: state.editProfileState.isLoading,
                      onUpdate: () {
                        if (_formKey.currentState!.validate()) {
                          final request = EditProfileRequestModel(
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            email: _emailController.text.trim(),
                            phone: _phoneController.text.trim(),
                            gender: state.selectedGender,
                          );
                          context
                              .read<ProfileCubit>()
                              .doIndented(EditProfileEvent(request));
                        }
                      },
                    ),
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
