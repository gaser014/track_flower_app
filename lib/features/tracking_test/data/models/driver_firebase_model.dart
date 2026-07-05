import '../../domain/entities/driver_entity.dart';
import 'location_model.dart';

/// Firestore representation of the driver attached to an order.
///
/// Uses manual (de)serialization to stay independent of build_runner.
class DriverFirebaseModel extends DriverEntity {
  const DriverFirebaseModel({
    super.id,
    super.name,
    super.phone,
    super.photo,
    super.location,
  });

  factory DriverFirebaseModel.fromJson(Map<String, dynamic> json) {
    final rawLocation = json['location'];
    return DriverFirebaseModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      photo: (json['photo'] ?? '').toString(),
      location: rawLocation is Map<String, dynamic>
          ? LocationModel.fromJson(rawLocation)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final loc = location;
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photo': photo,
      if (loc != null) 'location': LocationModel.fromEntity(loc).toJson(),
    };
  }

  factory DriverFirebaseModel.fromEntity(DriverEntity entity) {
    final loc = entity.location;
    return DriverFirebaseModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      photo: entity.photo,
      location: loc == null ? null : LocationModel.fromEntity(loc),
    );
  }
}
