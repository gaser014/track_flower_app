import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class MirrorOrderUseCase {
  final DriverOrdersRepository _repository;

  MirrorOrderUseCase(this._repository);

  Future<void> call(
    OrderEntity order, {
    double? driverLat,
    double? driverLng,
  }) {
    return _repository.mirrorOrderToFirebase(
      order,
      driverLat: driverLat,
      driverLng: driverLng,
    );
  }
}
