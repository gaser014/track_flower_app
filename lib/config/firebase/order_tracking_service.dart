import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/fcm/fcm_service.dart';
import 'package:track_flowers_app/config/fcm/user_entity.dart';

@lazySingleton
class OrderTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMService _fcmService = FCMService();

  static const String ordersCollection = 'orders';
  static const String usersCollection = 'users';

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection(ordersCollection);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(usersCollection);

  Future<void> upsertOrder(String orderId, Map<String, dynamic> data) async {
    if (orderId.isEmpty) return;
    try {
      await _orders.doc(orderId).set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, s) {
      log(
        'upsertOrder failed',
        name: 'OrderTrackingService',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> updateStatus({
    required String orderId,
    required String status,
    String? driverId,
    double? lat,
    double? lng,
  }) async {
    if (orderId.isEmpty) return;
    final data = <String, dynamic>{'orderId': orderId, 'status': status};
    if (driverId != null && driverId.isNotEmpty) data['driverId'] = driverId;
    if (lat != null && lng != null) {
      data['driverLocation'] = {'lat': lat, 'lng': lng};
    }
    await upsertOrder(orderId, data);
  }

  Future<void> updateDriverLocation({
    required String orderId,
    required double lat,
    required double lng,
  }) async {
    await upsertOrder(orderId, {
      'driverLocation': {'lat': lat, 'lng': lng},
    });
  }

  Stream<Map<String, dynamic>?> watchOrder(String orderId) {
    if (orderId.isEmpty) return const Stream.empty();
    return _orders.doc(orderId).snapshots().map((snapshot) => snapshot.data());
  }

  /// Fetch a user document from the `users` collection by id and parse the
  /// stored FCM tokens into a [UserEntity].
  Future<UserEntity?> getUser(String userId) async {
    if (userId.isEmpty) return null;
    try {
      final snapshot = await _users.doc(userId).get();
      final data = snapshot.data();
      if (data == null) return null;
      return UserEntity(userId: userId, fcmTokens: _parseFcmTokens(data));
    } catch (e, s) {
      log(
        'getUser failed',
        name: 'OrderTrackingService',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  /// Mirror the order onto the customer's user document so the customer app
  /// can read its latest order/driver state from `users/{userId}/orders/{id}`.
  Future<void> setUserOrder({
    required String userId,
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    if (userId.isEmpty || orderId.isEmpty) return;
    try {
      await _users.doc(userId).collection(ordersCollection).doc(orderId).set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, s) {
      log(
        'setUserOrder failed',
        name: 'OrderTrackingService',
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Resolve the user's FCM tokens by id and send a push notification.
  Future<void> notifyUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    final user = await getUser(userId);
    final tokens = user?.fcmTokens ?? const <FCMTokenEntity>[];
    if (tokens.isEmpty) {
      log('No FCM tokens found for user $userId', name: 'OrderTrackingService');
      return;
    }
    await _fcmService.sendNotification(
      targetFcmTokens: tokens,
      title: title,
      body: body,
    );
  }

  List<FCMTokenEntity> _parseFcmTokens(Map<String, dynamic> data) {
    final raw = data['fcmTokens'] ?? data['fcmToken'];
    final tokens = <FCMTokenEntity>[];

    void addToken(String token, [String lang = 'en']) {
      if (token.isEmpty) return;
      tokens.add(FCMTokenEntity(token: token, lang: lang));
    }

    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          addToken(
            (item['token'] ?? '').toString(),
            (item['lang'] ?? 'en').toString(),
          );
        } else if (item is String) {
          addToken(item);
        }
      }
    } else if (raw is Map) {
      addToken(
        (raw['token'] ?? '').toString(),
        (raw['lang'] ?? 'en').toString(),
      );
    } else if (raw is String) {
      addToken(raw);
    }

    return tokens;
  }
}
