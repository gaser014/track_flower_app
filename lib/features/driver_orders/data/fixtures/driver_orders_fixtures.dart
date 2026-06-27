import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

abstract class DriverOrdersFixtures {
  static const _store = StoreEntity(
    name: "Flowery store",
    address: "20th st, Sheikh Zayed, Giza",
    phone: "+20 100 000 0000",
  );

  static const _customer = CustomerEntity(
    name: "Nour mohamed",
    address: "20th st, Sheikh Zayed, Giza",
    phone: "+20 111 111 1111",
  );

  static const _items = [
    OrderItemEntity(
      name: "Red roses,15 Pink Rose Bouquet",
      price: 600,
      quantity: 1,
    ),
    OrderItemEntity(
      name: "Red roses,15 Pink Rose Bouquet",
      price: 600,
      quantity: 1,
    ),
  ];

  static OrderEntity order(String id, OrderStatus status) => OrderEntity(
    id: id,
    orderNumber: id,
    type: "Flower order",
    date: DateTime(2024, 9, 3, 11, 0),
    status: status,
    store: _store,
    customer: _customer,
    items: _items,
    totalPrice: 3000,
  );

  static OrderEntity get activeOrder => order("123456", OrderStatus.accepted);

  static List<OrderEntity> get pendingOrders => [
    order("223344", OrderStatus.pending),
    order("223345", OrderStatus.pending),
    order("223346", OrderStatus.pending),
  ];

  static List<OrderEntity> get myOrders => [
    order("123456", OrderStatus.completed),
    order("123457", OrderStatus.cancelled),
    order("123458", OrderStatus.completed),
    order("123459", OrderStatus.completed),
  ];
}
