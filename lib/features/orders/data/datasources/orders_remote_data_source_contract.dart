import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/orders/data/models/orders_response_model.dart';

abstract class OrdersRemoteDataSourceContract {
  Future<Result<OrdersResponseModel>> getOrders(PaginationParams params);
}
