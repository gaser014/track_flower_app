import 'location_entity.dart';

class OrderEntity {
  final String? id;
  final String status;
  final LocationEntity location;

  const OrderEntity({
    this.id,
    required this.status,
    required this.location,
  });
}
