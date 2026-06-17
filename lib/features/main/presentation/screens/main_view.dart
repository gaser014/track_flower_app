import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/main/presentation/screens/home_app_bar_widget.dart';
import 'package:track_flowers_app/features/main/presentation/screens/profile_appbar.dart';
import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_cubit.dart';
import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_events.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/pages/main_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  final List<Widget> _pages = const <Widget>[
    Center(child: Text('Categories')),
    Center(child: Text('Cart')),
    MainProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final selectedIndex = state.bottomNavIndex;
        return Scaffold(
          appBar: selectedIndex == 0
              ? const HomeAppBarWidget()
              : selectedIndex == 3
              ? const ProfileAppBarWidget()
              : null,
          body: IndexedStack(index: selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              cubit.doIndented(ChangeBottomNavIndexEvent(index));
            },
            type: BottomNavigationBarType.fixed,
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
                  AppAssets.iconsCategory,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 1
                        ? AppColors.primerColor
                        : AppColors.grayA6,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.categories,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.iconsCart,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 2
                        ? AppColors.primerColor
                        : AppColors.grayA6,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.cart,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.iconsProfile,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 3
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
