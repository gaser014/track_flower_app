import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/bike_painter.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/rider_painter.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/wheel_painter.dart';
import 'package:flutter/material.dart';

class OnboardingMotorbikeRider extends StatelessWidget {
  const OnboardingMotorbikeRider({super.key, required this.wheelSpinAnimation});

  final Animation<double> wheelSpinAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bike body
          Positioned(
            left: 20,
            top: 20,
            child: CustomPaint(
              size: const Size(140, 80),
              painter: BikePainter(),
            ),
          ),
          // Rider
          Positioned(
            left: 55,
            top: 0,
            child: CustomPaint(
              size: const Size(70, 70),
              painter: RiderPainter(),
            ),
          ),
          // Front wheel
          Positioned(
            right: 10,
            bottom: 5,
            child: _SpinningWheel(animation: wheelSpinAnimation),
          ),
          // Back wheel
          Positioned(
            left: 10,
            bottom: 5,
            child: _SpinningWheel(animation: wheelSpinAnimation),
          ),
          // Delivery boxes
          const Positioned(left: 10, top: 25, child: _DeliveryBoxes()),
        ],
      ),
    );
  }
}

class _SpinningWheel extends StatelessWidget {
  const _SpinningWheel({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(angle: animation.value, child: child);
      },
      child: CustomPaint(size: const Size(36, 36), painter: WheelPainter()),
    );
  }
}

class _DeliveryBoxes extends StatelessWidget {
  const _DeliveryBoxes();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 30,
          height: 25,
          decoration: BoxDecoration(
            color: AppColors.pinkD9,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Positioned(
          top: -8,
          left: 4,
          child: Container(
            width: 22,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primerColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }
}
