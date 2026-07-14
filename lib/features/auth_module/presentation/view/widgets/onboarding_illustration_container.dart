import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/onboarding_motorbike_rider.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/onboarding_phone_mockup.dart';
import 'package:flutter/material.dart';

class OnboardingIllustrationContainer extends StatelessWidget {
  const OnboardingIllustrationContainer({
    super.key,
    required this.bikeSlideIn,
    required this.bikeBobAnimation,
    required this.wheelSpinAnimation,
  });

  final Animation<Offset> bikeSlideIn;
  final Animation<double> bikeBobAnimation;
  final Animation<double> wheelSpinAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.pinkF9,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pink blob background
          Positioned(
            top: 30,
            left: 40,
            child: Container(
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.pinkF6,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          // Decorative dot — large
          Positioned(
            top: 50,
            left: 30,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primerColor,
              ),
            ),
          ),
          // Decorative dot — small
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pinkE1,
              ),
            ),
          ),
          // Phone with map
          const Positioned(top: 30, right: 40, child: OnboardingPhoneMockup()),
          // Animated motorbike + rider
          SlideTransition(
            position: bikeSlideIn,
            child: AnimatedBuilder(
              animation: bikeBobAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, bikeBobAnimation.value),
                child: child,
              ),
              child: OnboardingMotorbikeRider(
                wheelSpinAnimation: wheelSpinAnimation,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
