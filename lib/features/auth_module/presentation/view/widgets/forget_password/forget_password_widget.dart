import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/base_state/base_event.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';

import 'forget_password_view.dart';

class ForgetPasswordWidget extends StatefulWidget {
  const ForgetPasswordWidget({super.key});

  @override
  State<ForgetPasswordWidget> createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  late final AuthModuleCubit _cubit;
  late final StreamSubscription _subscription;
  
  final _pageController = PageController();

  final _emailController = TextEditingController();
  final _sendCodeFormKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _verifyCodeFormKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _resetPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AuthModuleCubit>();
    _subscription = _cubit.eventStream.listen((event) {
      switch (event) {
        case DisplayError():
          if (!mounted) return;
          CustomToast.showError(
            context: context,
            message: event.errorMsg,
          );
        case DisplaySuccess():
          if (!mounted) return;
          CustomToast.showSuccess(
            context: context,
            message: event.successMsg,
          );
        case NavigateEvent():
          if (!mounted) return;
          context.pushNamed(event.routeName, extra: event.extra);
        case PageChangeEvent():
          if (!mounted) return;
          _goToPage(event.page);
        case PopEvent():
          if (!mounted) return;
          if (context.canPop()) {
             context.pop();
          } else {
             context.go(Routes.login);
          }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _cubit.close();
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: ForgetPasswordView(
        pageController: _pageController,
        emailController: _emailController,
        otpController: _otpController,
        newPasswordController: _newPasswordController,
        confirmPasswordController: _confirmPasswordController,
        sendCodeFormKey: _sendCodeFormKey,
        verifyCodeFormKey: _verifyCodeFormKey,
        resetPasswordFormKey: _resetPasswordFormKey,
        goToPage: _goToPage,
      ),
    );
  }
}

