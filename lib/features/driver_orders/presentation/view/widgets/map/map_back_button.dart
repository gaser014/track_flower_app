import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

/// Pink circular back button that floats over the map (top-left in the design).
class MapBackButton extends StatelessWidget {
  const MapBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: AppColors.primerColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Transform.flip(
            flipX: isRTL,
            child: SvgPicture.asset(
              AppAssets.arrowBack,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteF9,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
