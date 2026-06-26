import 'package:equatable/equatable.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';

/// A single page of orders plus its pagination metadata.
class OrdersPageEntity extends Equatable {
  final List<OrderEntity> orders;
  final MetaEntity meta;

  const OrdersPageEntity({required this.orders, required this.meta});

  @override
  List<Object?> get props => [orders, meta];
}

class OrderEntity extends Equatable {
  final String id;
  final String orderNumber;
  final num totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final String createdAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.items,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    items,
  ];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String title;
  final String image;
  final num price;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, title, image, price, quantity];
}
