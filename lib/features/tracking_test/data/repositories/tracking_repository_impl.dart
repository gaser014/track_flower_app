import 'dart:developer';

import 'package:injectable/injectable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../data_sources/firestore_service.dart';
import '../models/order_firebase_model.dart';
import '../models/user_firebase_model.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  final FirestoreService firestoreService;

  TrackingRepositoryImpl({required this.firestoreService});

  @override
  Future<void> addUser(UserEntity user) {
    return firestoreService.addUser(UserFirebaseModel.fromEntity(user));
  }

  @override
  Future<String> addOrder(OrderEntity order) {
    return firestoreService.addOrder(OrderFirebaseModel.fromEntity(order));
  }

  @override
  Future<void> updateOrder(OrderEntity order) {
    return firestoreService.updateOrder(OrderFirebaseModel.fromEntity(order));
  }

  @override
  Future<void> upsertOrder(String orderId, Map<String, dynamic> data) {
    log('Upserting order with ID: $orderId and data: $data');
    final result = firestoreService.upsertOrder(orderId, data);
    return result;
  }

  @override
  Stream<OrderEntity?> getOrderStream(String orderId) {
    return firestoreService.getOrderStream(orderId);
  }
}
