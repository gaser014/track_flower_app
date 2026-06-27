import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class RiderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Body / jacket
    paint.color = AppColors.primerColor;
    final bodyPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.45)
      ..lineTo(size.width * 0.2, size.height * 0.75)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.75, size.height * 0.7)
      ..lineTo(size.width * 0.65, size.height * 0.45)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Helmet
    paint.color = AppColors.pinkD9;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.3),
        width: size.width * 0.4,
        height: size.height * 0.35,
      ),
      paint,
    );

    // Helmet visor
    paint.color = AppColors.black35.withValues(alpha: 0.5);
    final visorPath = Path()
      ..moveTo(size.width * 0.32, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.38,
        size.width * 0.68,
        size.height * 0.28,
      )
      ..lineTo(size.width * 0.62, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.28,
        size.width * 0.38,
        size.height * 0.22,
      )
      ..close();
    canvas.drawPath(visorPath, paint);

    // Arm
    paint.color = AppColors.primerColor;
    final armPath = Path()
      ..moveTo(size.width * 0.65, size.height * 0.5)
      ..lineTo(size.width * 0.85, size.height * 0.55)
      ..lineTo(size.width * 0.82, size.height * 0.62)
      ..lineTo(size.width * 0.62, size.height * 0.58)
      ..close();
    canvas.drawPath(armPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
