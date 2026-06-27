import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../config/fcm/fcm_service.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/add_order_use_case.dart';
import '../../domain/use_cases/add_user_use_case.dart';
import '../../domain/use_cases/stream_order_use_case.dart';
import '../../domain/use_cases/update_order_use_case.dart';
import '../../data/data_sources/firestore_service.dart';
import '../../data/repositories/tracking_repository_impl.dart';

class TrackingTestPage extends StatefulWidget {
  const TrackingTestPage({super.key});

  @override
  State<TrackingTestPage> createState() => _TrackingTestPageState();
}

class _TrackingTestPageState extends State<TrackingTestPage> {
  // Usually injected via Dependency Injection (e.g. get_it)
  late final TrackingRepositoryImpl _repository;
  late final AddUserUseCase _addUser;
  late final AddOrderUseCase _addOrder;
  late final UpdateOrderUseCase _updateOrder;
  late final StreamOrderUseCase _streamOrder;

  String? _currentOrderId;
  final String _dummyUserId = "driver_123";

  @override
  void initState() {
    super.initState();
    _repository = TrackingRepositoryImpl(firestoreService: FirestoreService());
    _addUser = AddUserUseCase(_repository);
    _addOrder = AddOrderUseCase(_repository);
    _updateOrder = UpdateOrderUseCase(_repository);
    _streamOrder = StreamOrderUseCase(_repository);
  }

  Future<void> _createDummyUserAndOrder() async {
    try {
      // 1. Create Dummy User via Use Case
      final userEntity = UserEntity(
        userId: _dummyUserId,
        fcmToken: "dummy_token_abc",
        location: const LocationEntity(
          lat: 30.0444,
          lng: 31.2357,
        ), // Cairo location
        language: "en",
      );
      await _addUser(userEntity);

      // 2. Create Dummy Order via Use Case
      final orderEntity = const OrderEntity(
        status: "Pending",
        location: LocationEntity(lat: 30.0444, lng: 31.2357),
      );
      final orderId = await _addOrder(orderEntity);

      setState(() {
        _currentOrderId = orderId;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created Dummy Data! Order ID: $orderId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateOrderStatusAndLocation() async {
    if (_currentOrderId == null) return;

    try {
      // Simulate driver moving and status changing via Use Case
      final updatedOrder = OrderEntity(
        id: _currentOrderId,
        status: "Out for Delivery",
        location: const LocationEntity(
          lat: 30.0500,
          lng: 31.2400,
        ), // Moved location
      );

      await _updateOrder(updatedOrder);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order location and status updated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _sendTestNotification() async {
    log(FCMService().fcmToken.toString(), name: 'FCM_TOKEN');
    try {
      await FCMService().sendNotification(
        targetFcmToken: FCMService().fcmToken.toString(),
        title: "Test Notification",
        body: "This is a test notification sent directly from the app!",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent to this device!')),
      );
    } catch (e) {
      log(e.toString(), name: 'FCM_NOTIFICATION_ERROR');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _createDummyUserAndOrder,
              label: const Text('1. Create Dummy User & Order'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.update),
              onPressed: _updateOrderStatusAndLocation,
              label: const Text('2. Update Order Location & Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              onPressed: _sendTestNotification,
              label: const Text('3. Send Test Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
            const Divider(height: 40),
            const Text(
              'Real-time Order Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _currentOrderId == null
                  ? const Center(
                      child: Text(
                        'No Order Created Yet. Press the first button.',
                      ),
                    )
                  : StreamBuilder<OrderEntity?>(
                      stream: _streamOrder(_currentOrderId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final order = snapshot.data;
                        if (order == null) {
                          return const Text('Order not found');
                        }

                        return Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID: ${order.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Chip(
                                      label: Text(
                                        order.status,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: order.status == 'Pending'
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Location (Real-time):',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('  Latitude: ${order.location.lat}'),
                                Text('  Longitude: ${order.location.lng}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
