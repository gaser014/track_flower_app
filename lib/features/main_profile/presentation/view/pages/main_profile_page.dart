import 'package:easy_localization/easy_localization.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/main_profile_cubit.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/widgets/profile_header_widget.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/widgets/profile_menu_item_widget.dart';

import 'package:track_flowers_app/features/main_profile/presentation/view/widgets/main_profile_shimmer.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<MainProfileCubit>()..fetchProfile(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MainProfileCubit, MainProfileStates>(
                builder: (context, state) {
                  if (state.profileState.isLoading) {
                    return const MainProfileShimmer();
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
                        await context.read<MainProfileCubit>().fetchProfile();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileHeaderWidget(user: user),

                            ProfileMenuItemWidget(
                              title: AppStrings.profile,
                              onTap: () {},
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.gray7D,
                              ),
                              icon: null,
                              leadingIconWidget: SvgPicture.asset(
                                AppAssets.iconsProfile,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.black32,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            ProfileMenuItemWidget(
                              title: AppStrings.myOrders,
                              onTap: () {},
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.gray7D,
                              ),
                              icon: null,
                              leadingIconWidget: SvgPicture.asset(
                                AppAssets.iconsTransactionOrder,
                                height: 24,
                              ),
                            ),
                            ProfileMenuItemWidget(
                              title: AppStrings.savedAddresses,
                              onTap: () {},
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.gray7D,
                              ),
                              icon: null,
                              leadingIconWidget: SvgPicture.asset(
                                AppAssets.iconsLocation,
                                height: 24,
                              ),
                            ),

                            const Divider(
                              color: AppColors.grayEA,
                              thickness: 1,
                            ),

                            ProfileMenuItemWidget(
                              title: AppStrings.notification,
                              onTap: () {},
                              leadingIconWidget: const SizedBox(width: 24),
                              trailing: Switch(
                                value: false,
                                onChanged: (val) {},
                                activeThumbColor: AppColors.white,
                                inactiveThumbColor: AppColors.gray7D,
                                activeTrackColor: AppColors.primerColor,
                                inactiveTrackColor: AppColors.grayEA,
                                trackOutlineColor: WidgetStateColor.resolveWith(
                                  (states) => AppColors.grayEA,
                                ),
                              ),
                            ),

                            const Divider(
                              color: AppColors.grayEA,
                              thickness: 1,
                            ),

                            ProfileMenuItemWidget(
                              title: AppStrings.language,
                              onTap: () {},
                              leadingIconWidget: SvgPicture.asset(
                                AppAssets.iconsTranslateLang,
                                height: 24,
                              ),
                              trailing: Text(
                                context.locale.languageCode == "ar"
                                    ? AppStrings.english
                                    : AppStrings.arabic,
                                style: AppFontStyle.regular14(
                                  context: context,
                                ).copyWith(color: AppColors.primerColor),
                              ),
                            ),
                            ProfileMenuItemWidget(
                              title: AppStrings.aboutUs,
                              onTap: () {},
                              leadingIconWidget: const SizedBox(width: 24),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.gray7D,
                              ),
                            ),
                            ProfileMenuItemWidget(
                              title: AppStrings.termsConditions,
                              onTap: () {},
                              leadingIconWidget: const SizedBox(width: 24),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.gray7D,
                              ),
                            ),

                            const Divider(
                              color: AppColors.grayEA,
                              thickness: 1,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.iconsLogout,
                                        height: 24,
                                      ),
                                      const Gap(16),
                                      Text(
                                        AppStrings.logout,
                                        style: AppFontStyle.regular16(
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

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
    );
  }
}
