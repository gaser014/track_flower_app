import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_app_bar.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/cubit/driver_orders_cubit.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/labeled_value_row.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_action_button.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_item_tile.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_location_tile.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_status_banner.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_status_label.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_steps_indicator.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    if (!order.status.isActive) {
      return OrderDetailsView(order: order);
    }

    return BlocProvider<DriverOrdersCubit>(
      create: (_) =>
          getIt<DriverOrdersCubit>()..doIntent(SetActiveOrderEvent(order)),
      child: BlocBuilder<DriverOrdersCubit, DriverOrdersStates>(
        buildWhen: (previous, current) =>
            previous.activeState != current.activeState,
        builder: (context, state) {
          final current = state.activeState.data ?? order;
          return OrderDetailsView(
            order: current,
            onAdvance: () => context.read<DriverOrdersCubit>().doIntent(
              const AdvanceOrderEvent(),
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.order, this.onAdvance});

  final OrderEntity order;
  final VoidCallback? onAdvance;

  /// Opens a map leg and, when the driver confirms arrival there, advances the
  /// order status via the parent [DriverOrdersCubit].
  Future<void> _openLeg(BuildContext context, String leg) async {
    final arrived = await context.push<bool>(
      '${Routes.main}/$leg',
      extra: order,
    );
    if (arrived == true) onAdvance?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = order.status.isActive;

    return Scaffold(
      backgroundColor: AppColors.whiteF9,
      appBar: CustomAppBar(title: AppStrings.orderDetails),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (isActive) ...[
                  OrderStepsIndicator(status: order.status),
                  const SizedBox(height: 16),
                  OrderStatusBanner(order: order),
                ] else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderStatusLabel(status: order.status),
                      Text(
                        "# ${order.orderNumber}",
                        style: AppFontStyle.semiBold16(context: context),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                PickupAddressTile(
                  store: order.store,
                  showActions: isActive,
                  onTap: isActive
                      ? () => _openLeg(context, Routes.pickupLocation)
                      : null,
                ),
                const SizedBox(height: 24),
                UserAddressTile(
                  customer: order.customer,
                  showActions: isActive,
                  onTap: isActive
                      ? () => _openLeg(context, Routes.userLocation)
                      : null,
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.orderDetails,
                  style: AppFontStyle.medium16(context: context),
                ),
                const SizedBox(height: 16),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OrderItemTile(item: item),
                  ),
                ),
                const SizedBox(height: 24),

                LabeledValueRow(
                  label: AppStrings.totalPrice,
                  value: "${AppStrings.egp} ${order.totalPrice}",
                ),
                const SizedBox(height: 24),

                LabeledValueRow(
                  label: AppStrings.paymentMethod,
                  value: AppStrings.cashOnDelivery,
                ),
              ],
            ),
          ),
          if (isActive && onAdvance != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: OrderActionButton(
                status: order.status,
                onPressed: onAdvance!,
              ),
            ),
        ],
      ),
    );
  }
}
