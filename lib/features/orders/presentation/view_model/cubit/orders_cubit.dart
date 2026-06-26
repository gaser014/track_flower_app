import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:track_flowers_app/features/orders/presentation/view_model/cubit/orders_events.dart';

part 'orders_states.dart';

@Injectable()
class OrdersCubit extends Cubit<OrdersStates> {
  OrdersCubit(this._getOrdersUseCase) : super(const OrdersStates());

  final GetOrdersUseCase _getOrdersUseCase;

  void doIntent(OrdersEvents event) {
    switch (event) {
      case GetOrdersEvent():
        _getOrders();
      case LoadMoreOrdersEvent():
        _loadMoreOrders();
    }
  }

  Future<void> _getOrders() async {
    emit(state.copyWith(ordersState: const BaseState.loading()));

    final result = await _getOrdersUseCase.call(const PaginationParams());
    result.when(
      success: (page) => emit(
        state.copyWith(
          ordersState: BaseState.success(page!.orders),
          meta: page.meta,
        ),
      ),
      error: (exception) =>
          emit(state.copyWith(ordersState: BaseState.error(exception))),
    );
  }

  Future<void> _loadMoreOrders() async {
    // Guard against duplicate triggers and the last page.
    if (state.isLoadingMore || !state.meta.hasNextPage) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getOrdersUseCase.call(
      PaginationParams(page: state.meta.nextPage),
    );
    result.when(
      success: (page) {
        final current = state.ordersState.data ?? const <OrderEntity>[];
        emit(
          state.copyWith(
            ordersState: BaseState.success([...current, ...page!.orders]),
            meta: page.meta,
            isLoadingMore: false,
          ),
        );
      },
      error: (_) => emit(state.copyWith(isLoadingMore: false)),
    );
  }
}
