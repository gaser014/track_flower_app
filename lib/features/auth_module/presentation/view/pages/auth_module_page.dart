
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/auth_module_body.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

class AuthModulePage extends StatefulWidget {
  const AuthModulePage({super.key});

  @override
  State<AuthModulePage> createState() => _AuthModulePageState();
}

class _AuthModulePageState extends State<AuthModulePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<AuthModuleCubit>()..loadSavedCredentials(),
      child: BlocConsumer<AuthModuleCubit, AuthModuleState>(
        listenWhen: (previous, current) =>
            previous.loginState != current.loginState ||
            previous.savedCredentials != current.savedCredentials,
        listener: (context, state) {
          if (state.savedCredentials.isSuccess &&
              state.savedCredentials.data != null) {
            final creds = state.savedCredentials.data!;
            _emailController.text = creds['driverSavedEmail'] ?? '';
            _passwordController.text = creds['driverSavedPassword'] ?? '';
          }
          if (state.loginState.isSuccess) {
            context.go(Routes.home);
            CustomToast(
              context: context,
              message: AppStrings.driverLoginSuccessfully,
            ).show();
          } else if (state.loginState.isError) {
            CustomToast(
              context: context,
              message: AppStrings.driverLoginError,
            ).show();
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthModuleCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: const BackButton(color: AppColors.black0C),
              title: Text(
                AppStrings.loginTitle,
                style: AppFontStyle.semiBold20(
                  context: context,
                ).copyWith(color: AppColors.black0C),
              ),
              titleSpacing: 0,
            ),
            body: AuthModuleBody(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              isPasswordVisible: state.showPasswordState.data ?? false,
              rememberMe: state.rememberMeState.data ?? false,
              isLoading: state.loginState.isLoading,
              onTogglePasswordVisibility: () {
                final isVisible = state.showPasswordState.data ?? false;
                cubit.doIndented(
                  ShowPasswordEvent(showPassword: !isVisible),
                );
              },
              onRememberMeChanged: (value) {
                cubit.doIndented(RememberMeEvent(rememberMe: value));
              },
              onForgotPasswordTapped: () {
                // TODO: navigate to forgot password
              },
              onSubmit: () {
                if (_formKey.currentState?.validate() ?? false) {
                  cubit.doIndented(
                    LoginEvent(
                      params: LoginParams(
                        email: _emailController.text,
                        password: _passwordController.text,
                        remember: state.rememberMeState.data ?? false,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
