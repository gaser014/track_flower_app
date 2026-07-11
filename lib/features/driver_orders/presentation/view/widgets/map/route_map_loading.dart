import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

/// Placeholder shown while the route (locations + polyline) is being resolved.
class RouteMapLoading extends StatelessWidget {
  const RouteMapLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.primerColor),
    );
  }
}
