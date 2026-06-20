import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';

class ApplicationSubmittedPage extends StatelessWidget {
  const ApplicationSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(height: 300, child: AnimatedWavesBackground()),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  CustomPaint(
                    size: const Size(130, 130),
                    painter: _CheckCirclePainter(),
                  ),

                  const SizedBox(height: 36),

                  Text(
                    AppStrings.yourApplicationHasBeenSubmitted,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.bold22(
                      context: context,
                    ).copyWith(color: AppColors.black0C, height: 1.4),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    AppStrings.thankYouForProvidingYourApplication,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.regular15(
                      context: context,
                    ).copyWith(color: AppColors.black5D, height: 1.6),
                  ),

                  const SizedBox(height: 48),

                  // Login Button
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      context.go(Routes.login);
                    },
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the pink check circle
class _CheckCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.065;

    final circlePaint = Paint()
      ..color = AppColors.primerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      _toRad(-200),
      _toRad(290),
      false,
      circlePaint,
    );

    // Draw checkmark
    final checkPaint = Paint()
      ..color = AppColors.primerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path();
    // Start point of tick
    checkPath.moveTo(size.width * 0.28, size.height * 0.52);
    // Mid point (bottom of tick)
    checkPath.lineTo(size.width * 0.45, size.height * 0.67);
    // End point (top-right of tick)
    checkPath.lineTo(size.width * 0.72, size.height * 0.38);

    canvas.drawPath(checkPath, checkPaint);
  }

  double _toRad(double degrees) => degrees * pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated Waves Widget
class AnimatedWavesBackground extends StatefulWidget {
  const AnimatedWavesBackground({super.key});

  @override
  State<AnimatedWavesBackground> createState() =>
      _AnimatedWavesBackgroundState();
}

class _AnimatedWavesBackgroundState extends State<AnimatedWavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Slower = less CPU
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 300),
          painter: _WavesPainter(_controller.value),
        );
      },
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double animValue;

  _WavesPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final double shift = animValue * 2 * pi;

    // Back wave — lightest
    _drawWave(
      canvas,
      size,
      color: const Color(0xffF9ECF0),
      yBase: 0.55,
      amplitude: 0.13,
      frequency: 1.5,
      phaseShift: shift,
    );

    // Middle wave
    _drawWave(
      canvas,
      size,
      color: const Color(0xffF6D2E1).withValues(alpha: 0.55),
      yBase: 0.68,
      amplitude: 0.11,
      frequency: 1.2,
      phaseShift: -shift + 1.0,
    );

    // Front wave — most opaque
    _drawWave(
      canvas,
      size,
      color: const Color(0xffF0B4CD).withValues(alpha: 0.35),
      yBase: 0.80,
      amplitude: 0.10,
      frequency: 1.8,
      phaseShift: shift + 2.0,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required Color color,
    required double yBase,
    required double amplitude,
    required double frequency,
    required double phaseShift,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 3) {
      final y =
          size.height * yBase +
          sin((x / size.width) * frequency * 2 * pi + phaseShift) *
              size.height *
              amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavesPainter old) => old.animValue != animValue;
}
