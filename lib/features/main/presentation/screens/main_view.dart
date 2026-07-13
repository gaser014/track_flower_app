import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_cubit.dart';
import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_events.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/pages/main_profile_page.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/pages/driver_home_page.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/pages/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  final List<Widget> _pages = const <Widget>[
    DriverHomePage(),
    MyOrdersPage(),
    MainProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final selectedIndex = state.bottomNavIndex;
        return Scaffold(
          backgroundColor: AppColors.whiteF9,
          body: IndexedStack(index: selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              cubit.doIndented(ChangeBottomNavIndexEvent(index));
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.whiteF9,
            selectedItemColor: AppColors.primerColor,
            unselectedItemColor: AppColors.grayA6,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.iconsHome,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 0
                        ? AppColors.primerColor
                        : AppColors.grayA6,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.iconsOrders,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 1
                        ? AppColors.primerColor
                        : AppColors.grayA6,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.orders,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.iconsProfile,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 2
                        ? AppColors.primerColor
                        : AppColors.grayA6,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.profile,
              ),
            ],
          ),
        );
      },
    );
  }
}
