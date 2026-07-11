import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/order_route_repository.dart';

/// Streams the driver's live position (device GPS) so the map can move the
/// driver marker without triggering any paid Google Maps requests.
@injectable
class WatchDriverLocationUseCase {
  final OrderRouteRepository _repository;

  WatchDriverLocationUseCase(this._repository);

  Stream<LatLngEntity> call() => _repository.watchDriverLocation();
}
