import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/orders/api/api_client/orders_api_client.dart';
import 'package:track_flowers_app/features/orders/data/datasources/orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/orders/data/models/orders_response_model.dart';

@Injectable(as: OrdersRemoteDataSourceContract)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSourceContract {
  final OrdersApiClient _apiClient;

  const OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<OrdersResponseModel>> getOrders(PaginationParams params) async {
    return await executeApi(() async {
      return await _apiClient.getOrders(params.page ?? 1, params.limit ?? 20);
    });
  }
}
