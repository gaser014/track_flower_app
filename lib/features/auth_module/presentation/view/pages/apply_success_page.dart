import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';

class ApplySuccessPage extends StatelessWidget {
  const ApplySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(AppAssets.bgImage, fit: BoxFit.cover),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    AppAssets.checkCircle,
                    width: 150,
                    height: 150,
                  ),
                  const Gap(32),
                  Text(
                    AppStrings.applicationSubmittedTitle,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.bold20(context: context),
                  ),
                  const Gap(16),
                  Text(
                    AppStrings.applicationSubmittedDesc,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.medium16(
                      context: context,
                    ).copyWith(color: AppColors.gray7D),
                  ),
                  const Gap(32),
                  CustomButton(
                    text: AppStrings.loginButton,
                    onPressed: () {
                      context.goNamed(Routes.login);
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
