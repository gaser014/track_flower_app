import 'package:flutter/material.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     // Flowery Logo & Name
            //     Row(
            //       children: [
            //         SvgPicture.asset(AppAssets.iconsFlower, height: 32),
            //         const Gap(4),
            //         Text(
            //           AppStrings.appTitle,
            //           style: AppFontStyle.bold20(
            //             context: context,
            //           ).copyWith(color: AppColors.primerColor),
            //         ),
            //       ],
            //     ),
            //     const Gap(12),
            //     // Search Bar
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {},
            //         borderRadius: BorderRadius.circular(12),
            //         child: Container(
            //           height: 48,
            //           decoration: BoxDecoration(
            //             color: AppColors.whiteF9,
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(color: AppColors.grayEA),
            //           ),
            //           child: Row(
            //             children: [
            //               const Gap(12),
            //               SvgPicture.asset(
            //                 AppAssets.iconsSearch,
            //                 colorFilter: const ColorFilter.mode(
            //                   AppColors.grayA6,
            //                   BlendMode.srcIn,
            //                 ),
            //               ),
            //               const Gap(8),
            //               Text(
            //                 AppStrings.search,
            //                 style: AppFontStyle.regular14(
            //                   context: context,
            //                 ).copyWith(color: AppColors.grayA6),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const Gap(12),
          ],
        ),
      ),
    );
  }
}
