import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/orders/domain/entities/order_entity.dart';

abstract class OrdersRepositoryContract {
  Future<Result<OrdersPageEntity>> getOrders(PaginationParams params);
}
