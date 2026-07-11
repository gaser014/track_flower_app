import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/profile/presentation/view/widgets/profile_shimmer.dart';
import 'package:track_flowers_app/core/widgets/custom_cached_image.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/features/profile/presentation/view/widgets/logout_confirmation_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<ProfileCubit>()..doIndented(GetProfileEvent()),
      child: BlocListener<ProfileCubit, ProfileStates>(
        listenWhen: (previous, current) => previous.logoutState != current.logoutState,
        listener: (context, state) {
          if (state.logoutState.isSuccess) {
            context.pop(); // close the dialog
            context.go(Routes.login);
          } else if (state.logoutState.isError) {
            context.pop(); // close the dialog
            CustomToast.showError(
              context: context,
              message: state.logoutState.exception?.toString() ?? 'Logout failed',
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileStates>(
                builder: (context, state) {
                  if (state.profileState.isLoading) {
                    return const ProfileShimmer();
                  } else if (state.profileState.isError) {
                    return Center(
                      child: Text(
                        state.profileState.exception?.toString() ?? "",
                      ),
                    );
                  }

                  if (state.profileState.isSuccess &&
                      state.profileState.data != null) {
                    final user = state.profileState.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProfileCubit>().doIndented(
                          GetProfileEvent(),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            _buildUserInfoCard(context, user),
                            const SizedBox(height: 16),
                            _buildVehicleInfoCard(context),
                            const SizedBox(height: 24),
                            _buildLanguageMenuItem(context),
                            const SizedBox(height: 16),
                            _buildLogoutMenuItem(context),
                            const SizedBox(height: 40),
                            Text(
                              "v 6.3.0 - (446)",
                              style: AppFontStyle.regular14(
                                context: context,
                              ).copyWith(color: AppColors.gray7D),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          const SizedBox(width: 8),
          Text(
            AppStrings.profile,
            style: AppFontStyle.bold20(context: context),
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_none, size: 28, color: AppColors.black),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primerColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, UserEntity user) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.editProfile, extra: user);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayEA),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grayEA,
              ),
              clipBehavior: Clip.antiAlias,
              child: user.photo != null && user.photo!.isNotEmpty
                  ? CustomCachedImage(
                      imagePath: user.photo!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 30, color: AppColors.gray7D),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
                    style: AppFontStyle.medium16(context: context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: AppFontStyle.regular14(context: context)
                        .copyWith(color: AppColors.gray53),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone ?? '',
                    style: AppFontStyle.regular14(context: context)
                        .copyWith(color: AppColors.gray53),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.black, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.editVehicle);
      },
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayEA),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vehicle info',
                style: AppFontStyle.medium16(context: context),
              ),
              const SizedBox(height: 4),
              Text(
                'Bike', // Static as per design since no API field provided
                style: AppFontStyle.regular14(context: context)
                    .copyWith(color: AppColors.gray53),
              ),
              const SizedBox(height: 4),
              Text(
                'UP16DL0007', // Static as per design since no API field provided
                style: AppFontStyle.regular14(context: context)
                    .copyWith(color: AppColors.gray53),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.black, size: 16),
        ],
      ),
      ),
    );
  }

  Widget _buildLanguageMenuItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.iconsTranslateLang,
            height: 24,
            colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          Text(
            AppStrings.language,
            style: AppFontStyle.regular16(context: context),
          ),
          const Spacer(),
          Text(
            context.locale.languageCode == "ar"
                ? AppStrings.arabic
                : AppStrings.english,
            style: AppFontStyle.medium14(context: context)
                .copyWith(color: AppColors.pink7C),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        LogoutConfirmationDialog.show(
          context,
          onConfirm: () {
            context.read<ProfileCubit>().doIndented(LogoutEvent());
          },
          isLoading: context.read<ProfileCubit>().state.logoutState.isLoading,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssets.iconsLogout,
              height: 24,
              colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
            const SizedBox(width: 16),
            Text(
              AppStrings.logout,
              style: AppFontStyle.regular16(context: context),
            ),
            const Spacer(),
            SvgPicture.asset(
              AppAssets.iconsLogout, // using logout icon as trailing as well, based on design it looks like a door exit icon
              height: 20,
              colorFilter: const ColorFilter.mode(AppColors.gray7D, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
