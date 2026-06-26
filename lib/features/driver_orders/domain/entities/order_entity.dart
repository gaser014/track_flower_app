import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';

class OrderStatusUi {
  final String label;
  final Color color;
  final IconData? icon;
  final String actionLabel;
  final bool canAdvance;

  const OrderStatusUi({
    required this.label,
    required this.color,
    this.icon,
    this.actionLabel = '',
    this.canAdvance = false,
  });
}

enum OrderStatus {
  pending(
    OrderStatusUi(
      label: AppStrings.statusPending,
      color: AppColors.primerColor,
    ),
  ),
  accepted(
    OrderStatusUi(
      label: AppStrings.statusAccepted,
      color: AppColors.green0C,
      actionLabel: AppStrings.arrivedAtPickup,
      canAdvance: true,
    ),
  ),
  picked(
    OrderStatusUi(
      label: AppStrings.statusPicked,
      color: AppColors.green0C,
      actionLabel: AppStrings.startDeliver,
      canAdvance: true,
    ),
  ),
  arrived(
    OrderStatusUi(
      label: AppStrings.statusArrived,
      color: AppColors.green0C,
      actionLabel: AppStrings.deliveredToUser,
      canAdvance: true,
    ),
  ),
  delivered(
    OrderStatusUi(
      label: AppStrings.statusDelivered,
      color: AppColors.green0C,
      actionLabel: AppStrings.deliveredToUser,
    ),
  ),
  completed(
    OrderStatusUi(
      label: AppStrings.statusCompleted,
      color: AppColors.green0C,
      icon: Icons.check_circle,
    ),
  ),
  cancelled(
    OrderStatusUi(
      label: AppStrings.statusCancelled,
      color: AppColors.redCC,
      icon: Icons.cancel,
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
    OrderStatus.accepted ||
    OrderStatus.picked ||
    OrderStatus.arrived ||
    OrderStatus.delivered => true,
    _ => false,
  };

  OrderStatus get next => switch (this) {
    OrderStatus.accepted => OrderStatus.picked,
    OrderStatus.picked => OrderStatus.arrived,
    OrderStatus.arrived => OrderStatus.delivered,
    OrderStatus.delivered => OrderStatus.completed,
    _ => this,
  };
}

class StoreEntity extends Equatable {
  final String name;
  final String address;
  final String phone;

  const StoreEntity({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, address, phone];
}

class CustomerEntity extends Equatable {
  final String name;
  final String address;
  final String phone;
  final String photo;

  const CustomerEntity({
    required this.name,
    required this.address,
    required this.phone,
    this.photo = "",
  });

  @override
  List<Object?> get props => [name, address, phone, photo];
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
