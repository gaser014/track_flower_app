import 'package:track_flowers_app/features/auth_module/domain/entities/profile_entity.dart';

/// Static profile data for UI testing purposes.
/// Token decoded from: eyJpZCI6IjY4NGRjNjgwMzA5ZGVmNGEzOWFiNWQxZiJ9
/// User ID: 684dc680309def4a39ab5d1f
class StaticProfileData {
  static final ProfileEntity profile = ProfileEntity(
    id: '684dc680309def4a39ab5d1f',
    firstName: 'Ahmed',
    lastName: 'Driver',
    email: 'driver@test.com',
    phone: '01012345678',
    gender: 'male',
    photo: null,
    vehicleType: 'Bike',
    vehicleNumber: 'UP16DL',
    vehicleLicense: 'A12345',
  );
}
