import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ProfileAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.iconsFlower, height: 32),
            const Gap(4),
            Text(
              AppStrings.appTitle,
              style: AppFontStyle.bold20(
                context: context,
              ).copyWith(color: AppColors.primerColor),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.iconsNotification,
                    height: 28,
                    width: 28,
                    colorFilter: ColorFilter.mode(
                      AppColors.pink7C,
                      BlendMode.srcIn,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: AppColors.pink7C,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
