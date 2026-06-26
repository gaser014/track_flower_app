import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:track_flowers_app/core/widgets/pagination_list_view.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/cubit/driver_orders_cubit.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/pending_order_card.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/shimmer/pending_order_card_shimmer.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DriverOrdersCubit>(
      create: (_) => getIt<DriverOrdersCubit>()
        ..doIntent(const GetActiveOrderEvent())
        ..doIntent(const GetPendingOrdersEvent()),
      child: const DriverHomeBody(),
    );
  }
}

class DriverHomeBody extends StatefulWidget {
  const DriverHomeBody({super.key});

  @override
  State<DriverHomeBody> createState() => _DriverHomeBodyState();
}

class _DriverHomeBodyState extends State<DriverHomeBody> {
  late final StreamSubscription<DriverOrdersUiEvent> _uiEventSubscription;

  @override
  void initState() {
    super.initState();
    _uiEventSubscription = context.read<DriverOrdersCubit>().eventStream.listen(
      _onUiEvent,
    );
  }

  void _onUiEvent(DriverOrdersUiEvent event) {
    if (event is OpenOrderDetailsUiEvent) {
      context.push('${Routes.main}/${Routes.orderDetails}', extra: event.order);
    } else if (event is ActiveOrderWarningUiEvent) {
      CustomToast.showInfo(
        context: context,
        message: AppStrings.activeOrderInProgress,
      );
    }
  }

  @override
  void dispose() {
    _uiEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              AppStrings.floweryRider,
              style: AppFontStyle.semiBold20(
                context: context,
              ).copyWith(color: AppColors.primerColor),
            ),
          ),
          Expanded(
            child: BlocBuilder<DriverOrdersCubit, DriverOrdersStates>(
              buildWhen: (previous, current) =>
                  previous.pendingState != current.pendingState,
              builder: (context, state) {
                final cubit = context.read<DriverOrdersCubit>();
                return PaginationListView<OrderEntity>(
                  state: state.pendingState,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  onRefresh: () async {
                    cubit.doIntent(const GetActiveOrderEvent());
                    cubit.doIntent(const GetPendingOrdersEvent());
                  },
                  onLoadMore: () =>
                      cubit.doIntent(const LoadMorePendingOrdersEvent()),
                  loadingWidget: const PendingOrdersListShimmer(),
                  emptyWidget: Text(
                    AppStrings.noPendingOrders,
                    style: AppFontStyle.medium16(context: context),
                  ),
                  errorWidget: Text(
                    AppStrings.somethingWentWrong,
                    style: AppFontStyle.medium16(context: context),
                  ),
                  itemBuilder: (context, order, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: PendingOrderCard(
                      order: order,
                      onAccept: () => cubit.doIntent(AcceptOrderEvent(order)),
                      onReject: () => cubit.doIntent(RejectOrderEvent(order)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
