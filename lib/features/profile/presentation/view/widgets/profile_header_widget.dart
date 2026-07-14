import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.grayEA,
          backgroundImage: user.photo != null && user.photo!.isNotEmpty
              ? NetworkImage(user.photo!)
              : null,
          child: user.photo == null || user.photo!.isEmpty
              ? const Icon(Icons.person, size: 50, color: AppColors.gray7D)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
          style: AppFontStyle.medium20(context: context),
        ),
        const SizedBox(height: 8),
        Text(
          user.email ?? '',
          style: AppFontStyle.regular16(
            context: context,
          ).copyWith(color: AppColors.gray7D),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
