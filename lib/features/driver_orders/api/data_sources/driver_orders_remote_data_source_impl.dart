import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/api/api_client/driver_orders_api_client.dart';
import 'package:track_flowers_app/features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';

@LazySingleton(as: DriverOrdersRemoteDataSourceContract)
class DriverOrdersRemoteDataSourceImpl
    implements DriverOrdersRemoteDataSourceContract {
  final DriverOrdersApiClient _apiClient;
  DriverOrdersRemoteDataSourceImpl({required DriverOrdersApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<List<OrderModel>>> getPendingOrders(PaginationParams params) =>
      executeApi<List<OrderModel>>(
        () => _apiClient.getPendingOrders(params.page ?? 1, params.limit ?? 20),
      );

  @override
  Future<Result<List<OrderModel>>> getMyOrders(PaginationParams params) =>
      executeApi<List<OrderModel>>(
        () => _apiClient.getMyOrders(params.page ?? 1, params.limit ?? 20),
      );

  @override
  Future<Result<OrderModel>> startOrder(String orderId) =>
      executeApi<OrderModel>(() => _apiClient.startOrder(orderId));

  @override
  Future<Result<OrderModel>> updateOrderState(String orderId, String state) =>
      executeApi<OrderModel>(() => _apiClient.updateOrderState(orderId, state));
}
