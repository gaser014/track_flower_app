import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';

abstract class DriverOrdersRemoteDataSourceContract {
  Future<Result<List<OrderModel>>> getPendingOrders(PaginationParams params);
  Future<Result<List<OrderModel>>> getMyOrders(PaginationParams params);
  Future<Result<OrderModel>> startOrder(String orderId);
  Future<Result<OrderModel>> updateOrderState(String orderId, String state);
}
