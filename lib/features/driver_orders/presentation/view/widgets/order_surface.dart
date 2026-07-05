import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

class OrderSurface extends StatelessWidget {
  const OrderSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.radius = 10,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.whiteF9,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [BoxShadow(color: Color(0x40535353), blurRadius: 2)],
      ),
      child: child,
    );
  }
}
