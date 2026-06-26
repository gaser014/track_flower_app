import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class GetPendingOrdersUseCase
    extends UseCase<BasePaginationEntity<OrderEntity>, PaginationParams> {
  final DriverOrdersRepository _repository;
  GetPendingOrdersUseCase(this._repository);

  @override
  Future<Result<BasePaginationEntity<OrderEntity>>> call(
    PaginationParams params,
  ) => _repository.getPendingOrders(params);
}
