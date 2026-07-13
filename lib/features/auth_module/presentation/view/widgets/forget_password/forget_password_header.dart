import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class ForgetPasswordHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ForgetPasswordHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppFontStyle.semiBold24(context: context),
        ),
        Gap(8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppFontStyle.regular16(context: context),
        ),
      ],
    );
  }
}
