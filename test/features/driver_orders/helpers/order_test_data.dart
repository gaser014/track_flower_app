import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

/// Shared fixtures for the driver_orders test suite.
///
/// Keeping the builders here avoids duplicating the (fairly large) order
/// graph across every use-case / repository / cubit test file.

OrderEntity buildOrder({
  String id = 'order-1',
  String userId = 'user-1',
  String orderNumber = '1001',
  OrderStatus status = OrderStatus.pending,
}) {
  return OrderEntity(
    id: id,
    userId: userId,
    orderNumber: orderNumber,
    type: 'Flower order',
    date: DateTime(2024, 1, 1),
    status: status,
    store: const StoreEntity(
      name: 'Flower Store',
      address: 'Cairo',
      phone: '0100000000',
    ),
    customer: const CustomerEntity(
      name: 'Ahmed Ali',
      address: 'Giza',
      phone: '0111111111',
    ),
    items: const [
      OrderItemEntity(name: 'Red Rose', price: 100, quantity: 2),
    ],
    totalPrice: 200,
  );
}

BasePaginationEntity<OrderEntity> buildOrdersPage(
  List<OrderEntity> data, {
  MetaEntity? meta,
}) {
  return BasePaginationEntity<OrderEntity>(
    meta: meta ?? const MetaEntity.empty(),
    data: data,
  );
}

OrderModel buildOrderModel({
  String id = 'order-1',
  String userId = 'user-1',
  String state = 'accepted',
}) {
  return OrderModel.fromJson({
    '_id': id,
    'user': {'_id': userId, 'firstName': 'Ahmed', 'lastName': 'Ali'},
    'orderNumber': '1001',
    'type': 'Flower order',
    'state': state,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'totalPrice': 200,
    'paymentType': 'cash',
    'store': {'name': 'Flower Store', 'address': 'Cairo', 'phone': '0100000000'},
    'orderItems': [
      {
        'product': {'title': 'Red Rose', 'imgCover': '', 'price': 100},
        'quantity': 2,
      },
    ],
  });
}

OrdersPageModel buildOrdersPageModel(
  List<OrderModel> orders, {
  MetaEntity? meta,
}) {
  return OrdersPageModel(orders: orders, meta: meta ?? const MetaEntity.empty());
}
