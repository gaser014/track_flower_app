import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/pagination_list_view.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_cubit.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/cubit/driver_orders_cubit.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/order_counter_card.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/recent_order_card.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/shimmer/recent_order_card_shimmer.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DriverOrdersCubit>(
      create: (_) =>
          getIt<DriverOrdersCubit>()..doIntent(const GetMyOrdersEvent()),
      child: const MyOrdersBody(),
    );
  }
}

class MyOrdersBody extends StatelessWidget {
  const MyOrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DriverOrdersCubit, DriverOrdersStates>(
        buildWhen: (previous, current) =>
            previous.myOrdersState != current.myOrdersState,
        builder: (context, state) {
          final cubit = context.read<DriverOrdersCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.myOrders,
                      style: AppFontStyle.semiBold20(context: context),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OrderCounterCard(
                            count: state.cancelledCount,
                            label: AppStrings.statusCancelled,
                            icon: Icons.cancel,
                            color: AppColors.redCC,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OrderCounterCard(
                            count: state.completedCount,
                            label: AppStrings.statusCompleted,
                            icon: Icons.check_circle,
                            color: AppColors.green0C,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.recentOrders,
                      style: AppFontStyle.medium18(context: context),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                child: PaginationListView<OrderEntity>(
                  state: state.myOrdersState,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  onRefresh: () async =>
                      cubit.doIntent(const GetMyOrdersEvent()),
                  onLoadMore: () =>
                      cubit.doIntent(const LoadMoreMyOrdersEvent()),
                  loadingWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: RecentOrdersListShimmer(),
                  ),
                  emptyWidget: Text(
                    AppStrings.noPendingOrders,
                    style: AppFontStyle.medium16(context: context),
                  ),
                  errorWidget: Text(
                    AppStrings.somethingWentWrong,
                    style: AppFontStyle.medium16(context: context),
                  ),
                  itemBuilder: (context, order, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RecentOrderCard(
                      order: order,
                      onTap: () => context.push(
                        '${Routes.main}/${Routes.orderDetails}',
                        extra: order,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
