import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingPhoneMockup extends StatelessWidget {
  const OnboardingPhoneMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppColors.shadowBox,
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Status bar
          Container(
            height: 6,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.gray10,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Map area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pinkF9,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Stack(
                children: [
                  // Route line
                  Positioned(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        color: AppColors.primerColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  // Start dot
                  Positioned(
                    left: 7,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primerColor,
                      ),
                    ),
                  ),
                  // End dot
                  Positioned(
                    left: 7,
                    bottom: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green0C,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom bar
          Container(
            height: 6,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.primerColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
