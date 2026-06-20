import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/delivery_animation_widget.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/onboarding_action_buttons.dart';

class OnboardingDriverPage extends StatefulWidget {
  const OnboardingDriverPage({super.key});

  @override
  State<OnboardingDriverPage> createState() => _OnboardingDriverPageState();
}

class _OnboardingDriverPageState extends State<OnboardingDriverPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DeliveryAnimationWidget(),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        AppStrings.welcomeToFlowery,
                        textAlign: TextAlign.center,
                        style: AppFontStyle.bold24(
                          context: context,
                        ).copyWith(color: AppColors.black0C, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: OnboardingActionButtons(
                  onLoginTapped: () => context.push(Routes.loginDriver),
                  onApplyTapped: () => context.push(Routes.register),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
