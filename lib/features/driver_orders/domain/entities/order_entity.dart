import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';

class OrderStatusUi {
  final String label;
  final Color color;
  final IconData? icon;
  final String actionLabel;
  final bool canAdvance;
  final int sortIndex;

  const OrderStatusUi({
    required this.label,
    required this.color,
    this.icon,
    this.actionLabel = '',
    this.canAdvance = false,
    this.sortIndex = 0,
  });
}

enum OrderStatus {
  pending(
    OrderStatusUi(
      label: AppStrings.statusPending,
      color: AppColors.primerColor,
      sortIndex: 1,
    ),
  ),
  accepted(
    OrderStatusUi(
      label: AppStrings.statusAccepted,
      color: AppColors.green0C,
      actionLabel: AppStrings.arrivedAtPickup,
      canAdvance: true,
      sortIndex: 2,
    ),
  ),
  picked(
    OrderStatusUi(
      label: AppStrings.statusPicked,
      color: AppColors.green0C,
      actionLabel: AppStrings.startDeliver,
      canAdvance: true,
      sortIndex: 3,
    ),
  ),
  arrived(
    OrderStatusUi(
      label: AppStrings.statusArrived,
      color: AppColors.green0C,
      // The driver's journey ends when they arrive at the customer. Marking the
      // order as "delivered" is the customer's action from their own app.
      sortIndex: 4,
    ),
  ),
  delivered(
    OrderStatusUi(
      label: AppStrings.statusDelivered,
      color: AppColors.green0C,
      // No action for the driver here: completing the order is the customer's
      // responsibility from their app. The driver's last step is "delivered".
      sortIndex: 5,
    ),
  ),
  completed(
    OrderStatusUi(
      label: AppStrings.statusCompleted,
      color: AppColors.green0C,
      icon: Icons.check_circle,
      sortIndex: 6,
    ),
  ),
  cancelled(
    OrderStatusUi(
      label: AppStrings.statusCancelled,
      color: AppColors.redCC,
      icon: Icons.cancel,
      sortIndex: 7,
    ),
  );

  final OrderStatusUi ui;
  const OrderStatus(this.ui);
}

enum PaymentMethod { cashOnDelivery }

extension OrderStatusX on OrderStatus {
  int get step => switch (this) {
    OrderStatus.accepted => 1,
    OrderStatus.picked => 2,
    OrderStatus.arrived => 3,
    OrderStatus.delivered || OrderStatus.completed => 4,
    _ => 0,
  };

  bool get isActive => switch (this) {
    OrderStatus.accepted || OrderStatus.picked || OrderStatus.arrived => true,
    // Once delivered, the order leaves the driver's active queue — it now waits
    // for the customer to confirm completion from their app.
    _ => false,
  };

  OrderStatus get next => switch (this) {
    OrderStatus.pending => OrderStatus.accepted,
    OrderStatus.accepted => OrderStatus.picked,
    OrderStatus.picked => OrderStatus.arrived,
    OrderStatus.arrived => OrderStatus.delivered,
    OrderStatus.delivered => OrderStatus.completed,
    _ => this,
  };

  /// Customer-facing notification body for the current status.
  String get notificationBody => switch (this) {
    OrderStatus.accepted => AppStrings.orderAcceptedBody,
    OrderStatus.picked => AppStrings.orderPickedBody,
    OrderStatus.arrived => AppStrings.orderArrivedBody,
    OrderStatus.delivered => AppStrings.orderDeliveredBody,
    OrderStatus.completed => AppStrings.orderCompletedBody,
    OrderStatus.cancelled => AppStrings.orderCancelledBody,
    OrderStatus.pending => AppStrings.orderUpdateBody,
  };
}

class StoreEntity extends Equatable {
  final String name;
  final String address;
  final String phone;
  final LatLngEntity? location;

  const StoreEntity({
    required this.name,
    required this.address,
    required this.phone,
    this.location,
  });

  @override
  List<Object?> get props => [name, address, phone, location];
}

class CustomerEntity extends Equatable {
  final String name;
  final String address;
  final String phone;
  final String photo;
  final LatLngEntity? location;

  const CustomerEntity({
    required this.name,
    required this.address,
    required this.phone,
    this.photo = "",
    this.location,
  });

  @override
  List<Object?> get props => [name, address, phone, photo, location];
}

class OrderItemEntity extends Equatable {
  final String name;
  final String image;
  final num price;
  final int quantity;

  const OrderItemEntity({
    required this.name,
    required this.price,
    required this.quantity,
    this.image = "",
  });

  @override
  List<Object?> get props => [name, image, price, quantity];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String orderNumber;
  final String type;
  final DateTime date;
  final OrderStatus status;
  final StoreEntity store;
  final CustomerEntity customer;
  final List<OrderItemEntity> items;
  final num totalPrice;
  final PaymentMethod paymentMethod;

  const OrderEntity({
    required this.id,
    this.userId = "",
    required this.orderNumber,
    required this.type,
    required this.date,
    required this.status,
    required this.store,
    required this.customer,
    required this.items,
    required this.totalPrice,
    this.paymentMethod = PaymentMethod.cashOnDelivery,
  });

  OrderEntity copyWith({OrderStatus? status}) {
    return OrderEntity(
      id: id,
      userId: userId,
      orderNumber: orderNumber,
      type: type,
      date: date,
      status: status ?? this.status,
      store: store,
      customer: customer,
      items: items,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    orderNumber,
    type,
    date,
    status,
    store,
    customer,
    items,
    totalPrice,
    paymentMethod,
  ];
}
