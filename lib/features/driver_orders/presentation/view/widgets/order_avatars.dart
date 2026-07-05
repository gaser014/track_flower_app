import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_cached_image.dart';

class FloweryStoreLogo extends StatelessWidget {
  const FloweryStoreLogo({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: AppColors.primerColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.iconsFlower,
            height: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteF9,
              BlendMode.srcIn,
            ),
          ),
          Text(
            AppStrings.appTitle,
            style: AppFontStyle.regular8(
              context: context,
            ).copyWith(color: AppColors.whiteF9),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.photo, this.size = 44});

  final String photo;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (photo.isEmpty) {
      return Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.pinkF9,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(AppAssets.iconsNoProfile),
      );
    }
    return ClipOval(
      child: CustomCachedImage(
        imagePath: photo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
