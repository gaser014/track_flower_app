import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_font_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final bool centerTitle;
  final EdgeInsetsGeometry? padding;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.padding,
    this.subTitle,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    final shouldShowBack = showBackButton && canPop;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: shouldShowBack ? 4 : 16,
      leading: shouldShowBack ? _BackButton(onPressed: onBackPressed) : null,
      leadingWidth: shouldShowBack && !isRTL ? 40 : 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFontStyle.medium20(
              context: context,
            ).copyWith(color: titleColor ?? AppColors.black0C),
          ),
          if (subTitle?.isNotEmpty ?? false)
            Text(
              subTitle ?? '',
              style: AppFontStyle.medium13().copyWith(color: AppColors.gray53),
            ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _BackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    log('Back button isRTL: $isRTL');
    return InkWell(
      onTap: onPressed ?? () => context.pop(),
      child: Transform.flip(
        flipX: isRTL,
        child: SvgPicture.asset(
          AppAssets.arrowBack,
          width: 20,
          height: 20,
          color: AppColors.black0C,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
