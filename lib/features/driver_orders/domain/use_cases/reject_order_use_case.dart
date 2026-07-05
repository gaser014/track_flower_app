import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class RejectOrderUseCase extends UseCase<OrderEntity, OrderEntity> {
  final DriverOrdersRepository _repository;
  RejectOrderUseCase(this._repository);

  @override
  Future<Result<OrderEntity>> call(OrderEntity params) =>
      _repository.rejectOrder(params);
}
