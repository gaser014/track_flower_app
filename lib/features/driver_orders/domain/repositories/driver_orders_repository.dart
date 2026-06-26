import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

abstract class DriverOrdersRepository {
  Future<Result<BasePaginationEntity<OrderEntity>>> getPendingOrders(
    PaginationParams params,
  );
  Future<Result<BasePaginationEntity<OrderEntity>>> getMyOrders(
    PaginationParams params,
  );
  Future<Result<OrderEntity>> getActiveOrder();
  Future<Result<OrderEntity>> acceptOrder(OrderEntity order);
  Future<Result<OrderEntity>> rejectOrder(OrderEntity order);
  Future<Result<OrderEntity>> startOrder(OrderEntity order);
  Future<Result<OrderEntity>> completeOrder(OrderEntity order);
}
