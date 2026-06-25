import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_firebase_model.dart';
import '../models/order_firebase_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  final String _usersCollection = 'users';
  final String _ordersCollection = 'orders';

  // ==========================================
  // USERS CRUD OPERATIONS
  // ==========================================

  /// Create or update a user document
  Future<void> addUser(UserFirebaseModel userModel) async {
    try {
      final data = userModel.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(_usersCollection)
          .doc(userModel.userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to add user: $e');
    }
  }

  /// Get user data
  Future<UserFirebaseModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      if (doc.exists && doc.data() != null) {
        return UserFirebaseModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get user: $e');
    }
  }

  /// Stream to get real-time user updates
  Stream<UserFirebaseModel?> getUserStream(String userId) {
    return _firestore.collection(_usersCollection).doc(userId).snapshots().map((
      doc,
    ) {
      if (doc.exists && doc.data() != null) {
        return UserFirebaseModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  /// Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_usersCollection).doc(userId).update(data);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to delete user: $e');
    }
  }

  // ==========================================
  // ORDERS CRUD OPERATIONS (Real-time enabled)
  // ==========================================

  /// Create a new order
  Future<String> addOrder(OrderFirebaseModel orderModel) async {
    try {
      final data = orderModel.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();
      final docRef = await _firestore.collection(_ordersCollection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  /// Get order data once
  Future<OrderFirebaseModel?> getOrder(String orderId) async {
    try {
      final doc = await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .get();
      if (doc.exists && doc.data() != null) {
        var data = doc.data()!;
        data['id'] = doc.id;
        return OrderFirebaseModel.fromJson(data);
      }
      return null;
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get order: $e');
    }
  }

  /// Stream to get real-time order status and location
  Stream<OrderFirebaseModel?> getOrderStream(String orderId) {
    return _firestore
        .collection(_ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            var data = doc.data()!;
            data['id'] = doc.id;
            return OrderFirebaseModel.fromJson(data);
          }
          return null;
        });
  }

  /// Update an order (e.g. status or location)
  Future<void> updateOrder(OrderFirebaseModel orderModel) async {
    try {
      if (orderModel.id == null)
        throw Exception('Order ID cannot be null for updating');
      final data = orderModel.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(_ordersCollection)
          .doc(orderModel.id)
          .update(data);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to update order: $e');
    }
  }

  /// Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).delete();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Stream all orders (Real-time updates for list of orders)
  Stream<List<OrderFirebaseModel>> getAllOrdersStream() {
    return _firestore.collection(_ordersCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return OrderFirebaseModel.fromJson(data);
      }).toList();
    });
  }
}
