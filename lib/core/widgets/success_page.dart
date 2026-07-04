import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/app_colors.dart';
import '../values/app_font_style.dart';
import 'custom_button.dart';

class SuccessPage extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessPage({
    super.key,
    this.title = 'Thank you!!',
    this.message = 'The order delivered\nsuccessfully',
    this.buttonText = 'Done',
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              const PulseCheckmark(),
              SizedBox(height: 40.h),
              Text(
                title,
                style: AppFontStyle.semiBold24(context: context).copyWith(
                  color: AppColors.green0C,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                message,
                style: AppFontStyle.medium20(context: context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black0C,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              CustomButton(
                text: buttonText,
                onPressed: onButtonPressed,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PulseCheckmark extends StatefulWidget {
  const PulseCheckmark({super.key});

  @override
  State<PulseCheckmark> createState() => _PulseCheckmarkState();
}

class _PulseCheckmarkState extends State<PulseCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _animation.value * 1.5,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green0C.withValues(alpha: 0.1),
                ),
              ),
            ),
            Transform.scale(
              scale: _animation.value * 1.25,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green0C.withValues(alpha: 0.2),
                ),
              ),
            ),
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green0C,
              ),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 50.w,
              ),
            ),
          ],
        );
      },
    );
  }
}
