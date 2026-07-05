import 'location_entity.dart';

class DriverEntity {
  final String id;
  final String name;
  final String phone;
  final String photo;
  final LocationEntity? location;

  const DriverEntity({
    this.id = '6a2f643b992612ae599a87c5',
    this.name = 'Ahmed Ali',
    this.phone = '+201010700888',
    this.photo = 'https://flower.elevateegy.com/uploads/default-profile.png',
    this.location = const LocationEntity(lat: 30.0444, lng: 31.2357),
  });
}
