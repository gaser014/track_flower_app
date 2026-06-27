class UserEntity {
  final String userId;
  final List<FCMTokenEntity> fcmTokens;

  const UserEntity({required this.userId, required this.fcmTokens});
}

class FCMTokenEntity {
  final String token;
  final String lang;

  const FCMTokenEntity({required this.token, required this.lang});
}
