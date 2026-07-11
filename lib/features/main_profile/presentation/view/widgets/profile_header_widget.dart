import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final fullName = [
      user.firstName,
      user.lastName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.pinkF9,
            backgroundImage: user.photo != null && user.photo!.isNotEmpty
                ? NetworkImage(user.photo!)
                : null,
            child: user.photo == null || user.photo!.isEmpty
                ? Image.asset(
                    AppAssets.iconsNoProfile,
                    width: 36,
                    height: 36,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person,
                      size: 36,
                      color: AppColors.gray7D,
                    ),
                  )
                : null,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fullName.isNotEmpty)
                  Text(
                    fullName,
                    style: AppFontStyle.semiBold16(context: context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (user.email != null && user.email!.isNotEmpty) ...[
                  const Gap(4),
                  Text(
                    user.email!,
                    style: AppFontStyle.regular14(
                      context: context,
                    ).copyWith(color: AppColors.gray7D),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
