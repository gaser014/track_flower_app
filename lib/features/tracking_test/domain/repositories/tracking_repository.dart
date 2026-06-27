import '../entities/order_entity.dart';
import '../entities/user_entity.dart';

abstract class TrackingRepository {
  Future<void> addUser(UserEntity user);
  Future<String> addOrder(OrderEntity order);
  Future<void> updateOrder(OrderEntity order);

  /// Create or merge a Firestore order document by id with arbitrary data.
  /// Used by other features (e.g. driver orders) to mirror their orders
  /// into the tracking collection.
  Future<void> upsertOrder(String orderId, Map<String, dynamic> data);

  Stream<OrderEntity?> getOrderStream(String orderId);
}
