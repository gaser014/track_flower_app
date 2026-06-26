import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    final isActive = order.status.isActive;

    return Scaffold(
      backgroundColor: AppColors.whiteF9,
      appBar: AppBar(
        backgroundColor: AppColors.whiteF9,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.main),
        ),
        title: Text(
          AppStrings.orderDetails,
          style: AppFontStyle.medium20(context: context),
        ),
        centerTitle: false,
      ),
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
                PickupAddressTile(store: order.store, showActions: isActive),
                const SizedBox(height: 16),
                UserAddressTile(
                  customer: order.customer,
                  showActions: isActive,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.orderDetails,
                  style: AppFontStyle.medium16(context: context),
                ),
                const SizedBox(height: 12),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OrderItemTile(item: item),
                  ),
                ),
                const Divider(color: AppColors.grayEA, height: 32),
                LabeledValueRow(
                  label: AppStrings.totalPrice,
                  value: "${AppStrings.egp} ${order.totalPrice}",
                ),
                const Divider(color: AppColors.grayEA, height: 32),
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
