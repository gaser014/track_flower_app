import 'location_entity.dart';

class UserEntity {
  final String userId;
  final String fcmToken;
  final LocationEntity location;
  final String language;

  const UserEntity({
    required this.userId,
    required this.fcmToken,
    required this.location,
    required this.language,
  });
}
