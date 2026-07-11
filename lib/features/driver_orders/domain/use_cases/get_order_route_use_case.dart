import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/order_route_repository.dart';

class GetOrderRouteParams {
  final OrderEntity order;
  final RouteMode mode;

  const GetOrderRouteParams({required this.order, required this.mode});
}

@injectable
class GetOrderRouteUseCase
    extends UseCase<OrderRouteEntity, GetOrderRouteParams> {
  final OrderRouteRepository _repository;

  GetOrderRouteUseCase(this._repository);

  @override
  Future<Result<OrderRouteEntity>> call(GetOrderRouteParams params) =>
      _repository.getOrderRoute(order: params.order, mode: params.mode);
}
