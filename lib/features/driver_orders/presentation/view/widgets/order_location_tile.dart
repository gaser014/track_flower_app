import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/address_call_actions.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_avatars.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_surface.dart';

class LabeledSection extends StatelessWidget {
  const LabeledSection({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyle.regular12(
            context: context,
          ).copyWith(color: AppColors.gray53),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}

class OrderLocationTile extends StatelessWidget {
  const OrderLocationTile({
    super.key,
    required this.leading,
    required this.title,
    required this.address,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final String address;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OrderSurface(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          leading,
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFontStyle.regular13(
                    context: context,
                  ).copyWith(color: AppColors.gray53),
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconsLocation,
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black0C,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        address,
                        style: AppFontStyle.regular13(
                          context: context,
                        ).copyWith(color: AppColors.black0C),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const Gap(8), trailing!],
        ],
      ),
    );
  }
}

class PickupAddressTile extends StatelessWidget {
  const PickupAddressTile({
    super.key,
    required this.store,
    this.showActions = false,
  });

  final StoreEntity store;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return LabeledSection(
      label: AppStrings.pickupAddress,
      child: OrderLocationTile(
        leading: const FloweryStoreLogo(),
        title: store.name,
        address: store.address,
        trailing: showActions ? AddressCallActions(phone: store.phone) : null,
      ),
    );
  }
}

class UserAddressTile extends StatelessWidget {
  const UserAddressTile({
    super.key,
    required this.customer,
    this.showActions = false,
  });

  final CustomerEntity customer;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return LabeledSection(
      label: AppStrings.userAddress,
      child: OrderLocationTile(
        leading: UserAvatar(photo: customer.photo),
        title: customer.name,
        address: customer.address,
        trailing: showActions
            ? AddressCallActions(phone: customer.phone)
            : null,
      ),
    );
  }
}
