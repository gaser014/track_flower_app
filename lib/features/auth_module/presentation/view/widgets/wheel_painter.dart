import 'dart:math' as math;

import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer tyre
    final tyrePaint = Paint()
      ..color = AppColors.black35
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius - 2.5, tyrePaint);

    // Rim
    final rimPaint = Paint()
      ..color = AppColors.grayA6
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 8, rimPaint);

    // Spokes
    final spokePaint = Paint()
      ..color = AppColors.grayA6
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      final spokeRadius = (radius - 8) * 0.9;
      final dx = spokeRadius * math.cos(angle);
      final dy = spokeRadius * math.sin(angle);
      canvas.drawLine(center, center.translate(dx, dy), spokePaint);
    }

    // Hub
    canvas.drawCircle(center, 5, Paint()..color = AppColors.black35);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
