import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/filter_param.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/api/api_client/driver_orders_api_client.dart';
import 'package:track_flowers_app/features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';

@LazySingleton(as: DriverOrdersRemoteDataSourceContract)
class DriverOrdersRemoteDataSourceImpl
    implements DriverOrdersRemoteDataSourceContract {
  final DriverOrdersApiClient _apiClient;
  DriverOrdersRemoteDataSourceImpl({required DriverOrdersApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<OrdersPageModel>> getPendingOrders(PaginationParams params) =>
      executeApi<OrdersPageModel>(
        () => _apiClient.getPendingOrders(_withSort(params)),
      );

  @override
  Future<Result<OrdersPageModel>> getMyOrders(PaginationParams params) =>
      executeApi<OrdersPageModel>(() => _apiClient.getMyOrders(params));

  @override
  Future<Result<OrderModel>> startOrder(String orderId) =>
      executeApi<OrderModel>(() => _apiClient.startOrder(orderId));

  @override
  Future<Result<OrderModel>> updateOrderState(String orderId, String state) =>
      executeApi<OrderModel>(
        () => _apiClient.updateOrderState(orderId, {'state': state}),
      );
  PaginationParams _withSort(PaginationParams params) => PaginationParams(
    page: params.page,
    limit: params.limit,
    filterList: [
      ...params.filterList,
      const FilterParam(key: 'sort', value: 'createdAt'),
    ],
  );
}
