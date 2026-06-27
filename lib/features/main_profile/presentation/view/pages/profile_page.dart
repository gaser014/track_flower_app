import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/pages/edit_profile_page.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_events.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/profile_states.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/pages/edit_vehicle_info_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/core/routes/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ProfileCubit>()..doIndented(GetProfileEvent()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text('Profile', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: false,
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: AppColors.black, size: 26),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.redCC,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('3', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
            const Gap(8),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state.getProfileState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.getProfileState.isSuccess) {
              final profile = state.getProfileState.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.grayEA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: profile?.photo != null ? NetworkImage(profile!.photo!) : null,
                              backgroundColor: AppColors.grayEA,
                              child: profile?.photo == null ? const Icon(Icons.person, size: 30, color: AppColors.gray7D) : null,
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${profile?.firstName ?? ''} ${profile?.lastName ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Gap(4),
                                  Text(profile?.email ?? 'No email', style: const TextStyle(color: AppColors.gray7D, fontSize: 14)),
                                  const Gap(4),
                                  Text(profile?.phone ?? '', style: const TextStyle(color: AppColors.gray7D, fontSize: 14)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.gray7D),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditVehicleInfoPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.grayEA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vehicle info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const Gap(8),
                                Text(profile?.vehicleType ?? 'Bike', style: const TextStyle(color: AppColors.gray7D, fontSize: 14)),
                                const Gap(4),
                                Text(profile?.vehicleNumber ?? 'UP16DL0007', style: const TextStyle(color: AppColors.gray7D, fontSize: 14)),
                              ],
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.gray7D),
                          ],
                        ),
                      ),
                    ),
                    const Gap(32),
                    InkWell(
                      onTap: () async {
                        if (context.locale.languageCode == "ar") {
                          await context.setLocale(const Locale('en', 'US'));
                        } else {
                          await context.setLocale(const Locale('ar', 'EG'));
                        }
                      },
                      child: _buildMenuItem(
                        Icons.language, 
                        'Language', 
                        trailing: Text(
                          context.locale.languageCode == "ar" ? 'English' : 'العربية', 
                          style: const TextStyle(color: AppColors.primerColor, fontSize: 12, fontWeight: FontWeight.bold)
                        )
                      ),
                    ),
                    const Gap(24),
                    InkWell(
                      onTap: () async {
                        try {
                           final dio = getIt.get<Dio>();
                           await dio.post(EndPoints.logout);
                        } catch (e) {
                           // ignore errors on logout
                        }
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        if (context.mounted) {
                           context.go(Routes.login);
                        }
                      },
                      child: _buildMenuItem(Icons.logout, 'Logout', trailing: const Icon(Icons.exit_to_app, color: AppColors.gray7D, size: 20)),
                    ),
                    const Gap(64),
                    const Text('v 6.3.0 - (446)', style: TextStyle(color: AppColors.gray7D, fontSize: 12)),
                  ],
                ),
              );
            } else if (state.getProfileState.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.getProfileState.exception.toString()}'),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().doIndented(GetProfileEvent()),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.black32, size: 20),
        const Gap(12),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black32)),
        const Spacer(),
        trailing ?? const SizedBox(),
      ],
    );
  }
}
