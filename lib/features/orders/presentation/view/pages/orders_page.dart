import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/orders/presentation/view/widgets/order_card.dart';
import 'package:track_flowers_app/features/orders/presentation/view_model/cubit/orders_cubit.dart';
import 'package:track_flowers_app/features/orders/presentation/view_model/cubit/orders_events.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<OrdersCubit>()..doIntent(GetOrdersEvent()),
      child: Scaffold(
        backgroundColor: AppColors.whiteF9,
        appBar: AppBar(
          backgroundColor: AppColors.whiteF9,
          title: Text(
            AppStrings.myOrders,
            style: AppFontStyle.semiBold18(context: context),
          ),
          centerTitle: true,
        ),
        body: const SafeArea(child: _OrdersBody()),
      ),
    );
  }
}

class _OrdersBody extends StatefulWidget {
  const _OrdersBody();

  @override
  State<_OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<_OrdersBody> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<OrdersCubit>().doIntent(LoadMoreOrdersEvent());
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    context.read<OrdersCubit>().doIntent(GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersStates>(
      builder: (context, state) {
        if (state.ordersState.isLoading || state.ordersState.isInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.ordersState.isError) {
          return _ErrorView(
            message:
                state.ordersState.exception?.toString() ??
                AppStrings.somethingWentWrong,
            onRetry: _refresh,
          );
        }

        final orders = state.ordersState.data ?? const [];
        if (orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
                Center(
                  child: Text(
                    "No orders yet",
                    style: AppFontStyle.medium16(context: context),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orders.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= orders.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return OrderCard(order: orders[index]);
            },
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFontStyle.regular14(context: context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
