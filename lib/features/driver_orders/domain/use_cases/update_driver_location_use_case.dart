import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/order_route_repository.dart';

/// Persists the driver's current position to the Firebase `orders` document.
/// The caller (cubit) only invokes this once the driver has moved a meaningful
/// distance, so Firestore writes stay minimal.
@injectable
class UpdateDriverLocationUseCase {
  final OrderRouteRepository _repository;

  UpdateDriverLocationUseCase(this._repository);

  Future<void> call({
    required String orderId,
    required LatLngEntity location,
  }) =>
      _repository.updateDriverLocation(orderId: orderId, location: location);
}
