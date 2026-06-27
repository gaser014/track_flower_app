import 'driver_entity.dart';
import 'location_entity.dart';

class OrderEntity {
  final String? id;
  final String status;
  final LocationEntity location;
  final DriverEntity? driver;

  const OrderEntity({
    this.id,
    required this.status,
    required this.location,
    this.driver,
  });
}
