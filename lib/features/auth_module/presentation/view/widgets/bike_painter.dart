import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class BikePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primerColor
      ..style = PaintingStyle.fill;

    // Main bike body
    final bodyPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.3)
      ..lineTo(size.width * 0.75, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.55)
      ..lineTo(size.width * 0.15, size.height * 0.55)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Engine block
    paint.color = AppColors.pinkD9;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.45,
          size.width * 0.4,
          size.height * 0.25,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Seat
    paint.color = AppColors.black35;
    final seatPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.15,
        size.width * 0.75,
        size.height * 0.28,
      )
      ..lineTo(size.width * 0.75, size.height * 0.32)
      ..lineTo(size.width * 0.3, size.height * 0.32)
      ..close();
    canvas.drawPath(seatPath, paint);

    // Handlebar
    paint.color = AppColors.black35;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.68,
          size.height * 0.1,
          size.width * 0.06,
          size.height * 0.25,
        ),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  @override
  bool boolRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
