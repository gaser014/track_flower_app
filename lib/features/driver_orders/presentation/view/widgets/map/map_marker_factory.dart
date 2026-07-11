import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

/// Builds custom Google Maps marker bitmaps that reproduce the Figma design:
/// a rounded pink pill with a white icon badge on the left and a white label.
///
/// Everything is painted on-device with a [Canvas] — no image assets and no
/// network calls, so it adds zero Google Maps cost.
abstract class MapMarkerFactory {
  /// Rendering scale for crisp markers on high-density screens.
  static const double _scale = 3.0;

  static Future<BitmapDescriptor> svgMarker({
    required String assetPath,
    double size = 48,
    /// Clockwise degrees applied while baking the SVG so rotation 0 faces north.
    double rotationDegrees = 0,
  }) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetPath), null);
    try {
      final double width = size * _scale;
      final double height =
          size * _scale * (pictureInfo.size.height / pictureInfo.size.width);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final scale = width / pictureInfo.size.width;

      canvas.translate(width / 2, height / 2);
      canvas.rotate(rotationDegrees * math.pi / 180);
      canvas.scale(scale);
      canvas.translate(
        -pictureInfo.size.width / 2,
        -pictureInfo.size.height / 2,
      );
      canvas.drawPicture(pictureInfo.picture);

      final image = await recorder
          .endRecording()
          .toImage(width.ceil(), height.ceil());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      return BitmapDescriptor.bytes(bytes, imagePixelRatio: _scale);
    } finally {
      pictureInfo.picture.dispose();
    }
  }

  static Future<BitmapDescriptor> pillMarker({
    required String label,
    required IconData icon,
    Color background = AppColors.primerColor,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Layout constants (logical px, multiplied by _scale when painting).
    const double height = 26;
    const double badge = 20;
    const double hPad = 4;
    const double gap = 4;
    const double fontSize = 11;

    // Measure the label.
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize * _scale,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double width =
        (hPad + badge + gap) * _scale + textPainter.width + hPad * _scale;
    final double totalHeight = height * _scale;

    // Pill background.
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, totalHeight),
      Radius.circular(totalHeight / 2),
    );
    canvas.drawRRect(rrect, Paint()..color = background);

    // White circular icon badge.
    final double badgeRadius = (badge * _scale) / 2;
    final Offset badgeCenter = Offset(
      hPad * _scale + badgeRadius,
      totalHeight / 2,
    );
    canvas.drawCircle(badgeCenter, badgeRadius, Paint()..color = Colors.white);

    // Icon glyph inside the badge.
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 12 * _scale,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: background,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - iconPainter.width / 2,
        badgeCenter.dy - iconPainter.height / 2,
      ),
    );

    // Label text.
    textPainter.paint(
      canvas,
      Offset(
        (hPad + badge + gap) * _scale,
        (totalHeight - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.ceil(), totalHeight.ceil());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(bytes, imagePixelRatio: _scale);
  }
}
