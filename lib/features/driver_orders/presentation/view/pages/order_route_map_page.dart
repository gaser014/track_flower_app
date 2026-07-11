import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/cubit/order_route_cubit.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/arrival_status_sheet.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/map_address_sheet.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/map_back_button.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/route_map_loading.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/widgets/map/route_map_view.dart';

/// Shared implementation for the two Figma map screens. [mode] selects whether
/// the route targets the store (pickup) or the customer (delivery), and also
/// controls the marker label and the order of the address cards.
class OrderRouteMapPage extends StatelessWidget {
  const OrderRouteMapPage({super.key, required this.order, required this.mode});

  final OrderEntity order;
  final RouteMode mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderRouteCubit>(
      create: (_) =>
          getIt<OrderRouteCubit>()
            ..doIntent(LoadOrderRouteEvent(order: order, mode: mode)),
      child: OrderRouteMapView(order: order, mode: mode),
    );
  }
}

class OrderRouteMapView extends StatelessWidget {
  const OrderRouteMapView({super.key, required this.order, required this.mode});

  final OrderEntity order;
  final RouteMode mode;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.whiteF9,
      body: Stack(
        children: [
          Positioned.fill(
            child: BlocConsumer<OrderRouteCubit, OrderRouteStates>(
              listenWhen: (p, c) => !p.hasArrived && c.hasArrived,
              listener: (context, state) => _onArrived(context),
              buildWhen: (p, c) =>
                  p.routeState != c.routeState ||
                  p.liveDriverLocation != c.liveDriverLocation,
              builder: (context, state) {
                return state.routeState.when(
                  initial: () => const RouteMapLoading(),
                  loading: () => const RouteMapLoading(),
                  success: (route) => RouteMapView(
                    route: route,
                    mode: mode,
                    driverLocation: state.liveDriverLocation,
                  ),
                  error: (_) => const _RouteError(),
                );
              },
            ),
          ),
          Positioned(top: topInset + 8, left: 16, child: const MapBackButton()),
          Align(
            alignment: Alignment.bottomCenter,
            child: MapAddressSheet(order: order, mode: mode),
          ),
        ],
      ),
    );
  }

  /// The driver reached the destination: prompt a status update. Confirming
  /// pops this screen returning `true`, so order details advances the status.
  Future<void> _onArrived(BuildContext context) async {
    final confirmed = await showArrivalStatusSheet(
      context,
      order: order,
      mode: mode,
    );
    if (confirmed == true && context.mounted) context.pop(true);
  }
}

class _RouteError extends StatelessWidget {
  const _RouteError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        AppStrings.routeUnavailable,
        textAlign: TextAlign.center,
        style: AppFontStyle.regular14(
          context: context,
        ).copyWith(color: AppColors.gray53),
      ),
    );
  }
}
