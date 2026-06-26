import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/driver_orders/data/fixtures/driver_orders_fixtures.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@LazySingleton(as: DriverOrdersRepository)
class DriverOrdersRepositoryImpl implements DriverOrdersRepository {
  final DriverOrdersRemoteDataSourceContract _remoteDataSource;
  DriverOrdersRepositoryImpl({
    required DriverOrdersRemoteDataSourceContract remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<BasePaginationEntity<OrderEntity>>> getPendingOrders(
    PaginationParams params,
  ) async {
    final result = await _remoteDataSource.getPendingOrders(params);
    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData(
        params: params,
        allData: DriverOrdersFixtures.pendingOrders,
      ),
      success: (data) => Success(
        data: BasePaginationEntity(
          meta: const MetaEntity.empty(),
          data: data?.map((e) => e.toEntity()).toList() ?? const [],
        ),
      ),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<BasePaginationEntity<OrderEntity>>> getMyOrders(
    PaginationParams params,
  ) async {
    final result = await _remoteDataSource.getMyOrders(params);
    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData(
        params: params,
        allData: DriverOrdersFixtures.myOrders,
      ),
      success: (data) => Success(
        data: BasePaginationEntity(
          meta: const MetaEntity.empty(),
          data: _dedupeById(data ?? const []),
        ),
      ),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<OrderEntity>> getActiveOrder() async {
    final result = await _remoteDataSource.getMyOrders(
      const PaginationParams(page: 1, limit: 50),
    );
    return result.makeDummyData<OrderEntity>(
      success: (data) {
        final orders = _dedupeById(data ?? const []);
        OrderEntity? active;
        for (final order in orders) {
          if (order.status.isActive) {
            active = order;
            break;
          }
        }
        return Success<OrderEntity>(data: active);
      },
      error: (_) => const Success<OrderEntity>(data: null),
    );
  }

  List<OrderEntity> _dedupeById(List<OrderModel> models) {
    final seen = <String>{};
    final result = <OrderEntity>[];
    for (final model in models) {
      if (seen.add(model.id)) result.add(model.toEntity());
    }
    return result;
  }

  @override
  Future<Result<OrderEntity>> acceptOrder(OrderEntity order) async =>
      Success(data: order.copyWith(status: OrderStatus.accepted));

  @override
  Future<Result<OrderEntity>> rejectOrder(OrderEntity order) async =>
      Success(data: order);

  @override
  Future<Result<OrderEntity>> startOrder(OrderEntity order) async {
    final result = await _remoteDataSource.startOrder(order.id);
    return result.makeDummyData(
      dummyData: order.copyWith(status: order.status.next),
      success: (data) => Success(data: data?.toEntity()),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<OrderEntity>> completeOrder(OrderEntity order) async {
    final result = await _remoteDataSource.updateOrderState(
      order.id,
      'completed',
    );
    return result.makeDummyData(
      dummyData: order.copyWith(status: OrderStatus.completed),
      success: (data) => Success(data: data?.toEntity()),
      error: (exception) => Error(exception: exception),
    );
  }
}
