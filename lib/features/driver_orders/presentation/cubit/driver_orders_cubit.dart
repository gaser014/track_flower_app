import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/base_state/pagination_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/config/fcm/fcm_service.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/accept_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_my_orders_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/mirror_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/reject_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/start_order_use_case.dart';

part 'driver_orders_events.dart';
part 'driver_orders_states.dart';

@injectable
class DriverOrdersCubit
    extends BaseCubit<DriverOrdersStates, DriverOrdersUiEvent> {
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final GetMyOrdersUseCase _getMyOrdersUseCase;
  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final AcceptOrderUseCase _acceptOrderUseCase;
  final RejectOrderUseCase _rejectOrderUseCase;
  final StartOrderUseCase _startOrderUseCase;
  final MirrorOrderUseCase _mirrorOrderUseCase;

  DriverOrdersCubit({
    required GetPendingOrdersUseCase getPendingOrdersUseCase,
    required GetMyOrdersUseCase getMyOrdersUseCase,
    required GetActiveOrderUseCase getActiveOrderUseCase,
    required AcceptOrderUseCase acceptOrderUseCase,
    required RejectOrderUseCase rejectOrderUseCase,
    required StartOrderUseCase startOrderUseCase,
    required MirrorOrderUseCase mirrorOrderUseCase,
  }) : _getPendingOrdersUseCase = getPendingOrdersUseCase,
       _getMyOrdersUseCase = getMyOrdersUseCase,
       _getActiveOrderUseCase = getActiveOrderUseCase,
       _acceptOrderUseCase = acceptOrderUseCase,
       _rejectOrderUseCase = rejectOrderUseCase,
       _startOrderUseCase = startOrderUseCase,
       _mirrorOrderUseCase = mirrorOrderUseCase,
       super(const DriverOrdersStates()) {
    _listenForCustomerPush();
  }

  /// Subscription to customer-triggered order-status pushes (delivery
  /// confirmation) so the driver's active order and list update live.
  StreamSubscription<OrderStatusPush>? _orderStatusSub;

  @override
  void emit(DriverOrdersStates state) {
    if (!isClosed) super.emit(state);
  }

  void _listenForCustomerPush() {
    _orderStatusSub = FCMService().orderStatusStream.listen(_onOrderStatusPush);
  }

  /// The customer confirmed receipt → reflect the new status on the driver's
  /// active order and orders list without any manual refresh.
  void _onOrderStatusPush(OrderStatusPush push) {
    if (isClosed) return;
    final status = _statusFromString(push.status);

    final active = state.activeState.data;
    if (active != null && active.id == push.orderId) {
      emit(
        state.copyWith(
          activeState: BaseState.success(active.copyWith(status: status)),
        ),
      );
    }

    final myOrders = state.myOrdersState.data;
    if (myOrders.any((o) => o.id == push.orderId)) {
      final updated = myOrders
          .map((o) => o.id == push.orderId ? o.copyWith(status: status) : o)
          .toList();
      emit(
        state.copyWith(myOrdersState: state.myOrdersState.withData(updated)),
      );
    }
  }

  OrderStatus _statusFromString(String value) => switch (value.toLowerCase()) {
    'accepted' => OrderStatus.accepted,
    'picked' => OrderStatus.picked,
    'arrived' => OrderStatus.arrived,
    'delivered' => OrderStatus.delivered,
    'completed' => OrderStatus.completed,
    'cancelled' || 'canceled' => OrderStatus.cancelled,
    _ => OrderStatus.pending,
  };

  Future<void> doIntent(DriverOrdersEvents event) async => switch (event) {
    GetPendingOrdersEvent() => _getPendingOrders(),
    LoadMorePendingOrdersEvent() => _loadMorePendingOrders(),
    GetMyOrdersEvent() => _getMyOrders(),
    LoadMoreMyOrdersEvent() => _loadMoreMyOrders(),
    GetActiveOrderEvent() => _getActiveOrder(),
    SetActiveOrderEvent() => _setActiveOrder(event.order),
    AcceptOrderEvent() => _acceptOrder(event.order),
    RejectOrderEvent() => _rejectOrder(event.order),
    AdvanceOrderEvent() => _advanceOrder(),
  };

  BasePaginationEntity<OrderEntity> get _emptyPage =>
      BasePaginationEntity(meta: const MetaEntity.empty(), data: const []);

  Future<void> _getPendingOrders() async {
    if (state.pendingState.isLoading) return;
    emit(state.copyWith(pendingState: state.pendingState.toLoading()));
    final result = await _getPendingOrdersUseCase(state.pendingState.query);
    result.when(
      success: (entity) => emit(
        state.copyWith(
          pendingState: state.pendingState.toSuccessFromEntity(
            entity ?? _emptyPage,
          ),
        ),
      ),
      error: (e) => emit(
        state.copyWith(
          pendingState: state.pendingState.toError(e ?? Exception('Unknown')),
        ),
      ),
    );
  }

  Future<void> _loadMorePendingOrders() async {
    if (!state.pendingState.canLoadMore) return;
    emit(state.copyWith(pendingState: state.pendingState.toLoadingMore()));
    final result = await _getPendingOrdersUseCase(state.pendingState.query);
    result.when(
      success: (entity) => emit(
        state.copyWith(
          pendingState: state.pendingState.toSuccessFromEntity(
            entity ?? _emptyPage,
          ),
        ),
      ),
      error: (e) => emit(
        state.copyWith(
          pendingState: state.pendingState.toErrorMore(
            e ?? Exception('Unknown'),
          ),
        ),
      ),
    );
  }

  Future<void> _getMyOrders() async {
    if (state.myOrdersState.isLoading) return;
    emit(state.copyWith(myOrdersState: state.myOrdersState.toLoading()));
    final result = await _getMyOrdersUseCase(state.myOrdersState.query);
    result.when(
      success: (entity) => emit(
        state.copyWith(
          myOrdersState: state.myOrdersState.toSuccessFromEntity(
            entity ?? _emptyPage,
          ),
        ),
      ),
      error: (e) => emit(
        state.copyWith(
          myOrdersState: state.myOrdersState.toError(e ?? Exception('Unknown')),
        ),
      ),
    );
  }

  Future<void> _loadMoreMyOrders() async {
    if (!state.myOrdersState.canLoadMore) return;
    emit(state.copyWith(myOrdersState: state.myOrdersState.toLoadingMore()));
    final result = await _getMyOrdersUseCase(state.myOrdersState.query);
    result.when(
      success: (entity) => emit(
        state.copyWith(
          myOrdersState: state.myOrdersState.toSuccessFromEntity(
            entity ?? _emptyPage,
          ),
        ),
      ),
      error: (e) => emit(
        state.copyWith(
          myOrdersState: state.myOrdersState.toErrorMore(
            e ?? Exception('Unknown'),
          ),
        ),
      ),
    );
  }

  Future<void> _getActiveOrder() async {
    emit(state.copyWith(activeState: const BaseState.loading()));
    final result = await _getActiveOrderUseCase(const NoParams());
    result.when(
      success: (data) => emit(
        state.copyWith(
          activeState: data != null
              ? BaseState.success(data)
              : const BaseState.initial(),
        ),
      ),
      error: (e) => emit(
        state.copyWith(activeState: BaseState.error(e ?? Exception('Unknown'))),
      ),
    );
  }

  Future<void> _setActiveOrder(OrderEntity order) async {
    emit(state.copyWith(activeState: BaseState.success(order)));
  }

  Future<void> _acceptOrder(OrderEntity order) async {
    final active = state.activeState.data;
    if (active != null && active.status.isActive) {
      emitEvent(const ActiveOrderWarningUiEvent());
      return;
    }
    final result = await _acceptOrderUseCase(order);
    result.when(
      success: (data) {
        final accepted = data ?? order.copyWith(status: OrderStatus.accepted);
        final remaining = state.pendingState.data
            .where((o) => o.id != order.id)
            .toList();
        emit(
          state.copyWith(
            pendingState: state.pendingState.withData(remaining),
            activeState: BaseState.success(accepted),
          ),
        );
        unawaited(_mirrorOrderUseCase(accepted));
        emitEvent(OpenOrderDetailsUiEvent(accepted));
      },
      error: (_) {},
    );
  }

  Future<void> _rejectOrder(OrderEntity order) async {
    final result = await _rejectOrderUseCase(order);
    result.when(
      success: (_) {
        final remaining = state.pendingState.data
            .where((o) => o.id != order.id)
            .toList();
        emit(
          state.copyWith(pendingState: state.pendingState.withData(remaining)),
        );
      },
      error: (_) {},
    );
  }

  Future<void> _advanceOrder() async {
    final current = state.activeState.data;
    if (current == null) return;

    // The driver can only advance up to "arrived". Confirming delivery/receipt
    // (and completing the order) is exclusively the customer's action.
    if (current.status == OrderStatus.arrived ||
        current.status == OrderStatus.delivered ||
        current.status == OrderStatus.completed) {
      return;
    }

    // Heading to the store is backed by the "start order" API call; every other
    // step just advances locally and mirrors to Firebase + notifies the customer.
    if (current.status == OrderStatus.accepted) {
      final result = await _startOrderUseCase(current);
      result.when(
        success: (_) {
          final next = current.copyWith(status: OrderStatus.picked);
          emit(state.copyWith(activeState: BaseState.success(next)));
          unawaited(_mirrorOrderUseCase(next));
        },
        error: (e) => emit(
          state.copyWith(
            activeState: BaseState.error(e ?? Exception('Unknown')),
          ),
        ),
      );
      return;
    }

    // picked -> arrived (driver's final step).
    final next = current.copyWith(status: current.status.next);
    emit(state.copyWith(activeState: BaseState.success(next)));
    unawaited(_mirrorOrderUseCase(next));
  }

  @override
  Future<void> close() {
    _orderStatusSub?.cancel();
    return super.close();
  }
}
