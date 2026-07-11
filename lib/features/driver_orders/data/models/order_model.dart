import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

OrderStatus orderStatusFromString(String value) =>
    switch (value.toLowerCase()) {
      'accepted' || 'inprogress' => OrderStatus.accepted,
      'picked' => OrderStatus.picked,
      'arrived' => OrderStatus.arrived,
      'delivered' => OrderStatus.delivered,
      'completed' => OrderStatus.completed,
      'cancelled' || 'canceled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };

class OrderModel {
  final String id;
  final String userId;
  final String orderNumber;
  final String type;
  final String state;
  final String createdAt;
  final num totalPrice;
  final String paymentType;
  final StoreModel store;
  final CustomerModel customer;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    this.userId = '',
    required this.orderNumber,
    required this.type,
    required this.state,
    required this.createdAt,
    required this.totalPrice,
    required this.paymentType,
    required this.store,
    required this.customer,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'] is Map
        ? Map<String, dynamic>.from(json['order'] as Map)
        : json;
    final store = json['store'] is Map ? json['store'] : order['store'];
    final user = order['user'] is Map ? order['user'] as Map : const {};
    return OrderModel(
      id: order['_id'] ?? order['id'] ?? '',
      userId:
          (user['_id'] ?? user['id'] ?? order['userId'] ?? order['user'] ?? '')
              .toString(),
      orderNumber: (order['orderNumber'] ?? '')
          .toString()
          .replaceAll('#', '')
          .trim(),
      type: order['type'] ?? 'Flower order',
      state: order['state'] ?? order['status'] ?? 'pending',
      createdAt: order['createdAt'] ?? '',
      totalPrice: order['totalPrice'] ?? order['totalOrderPrice'] ?? 0,
      paymentType: order['paymentType'] ?? '',
      store: StoreModel.fromJson(
        store is Map ? Map<String, dynamic>.from(store) : const {},
      ),
      customer: CustomerModel.fromJson(order),
      items:
          (order['orderItems'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  OrderEntity toEntity() => OrderEntity(
    id: id,
    userId: userId,
    orderNumber: orderNumber,
    type: type,
    date: DateTime.tryParse(createdAt)?.toLocal() ?? DateTime.now(),
    status: orderStatusFromString(state),
    store: store.toEntity(),
    customer: customer.toEntity(),
    items: items.map((e) => e.toEntity()).toList(),
    totalPrice: totalPrice,
  );
}

class StoreModel {
  final String name;
  final String address;
  final String phone;
  final LatLngEntity? location;

  const StoreModel({
    required this.name,
    required this.address,
    required this.phone,
    this.location,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    phone: json['phoneNumber'] ?? json['phone'] ?? '',
    // API sends `latLong` as a "lat,long" string; also tolerate flat fields.
    location: LatLngEntity(lat: 30.9456534, lng: 31.2922893),
  );

  StoreEntity toEntity() => StoreEntity(
    name: name,
    address: address,
    phone: phone,
    location: location,
  );
}

class CustomerModel {
  final String name;
  final String address;
  final String phone;
  final String photo;
  final LatLngEntity? location;

  const CustomerModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.photo,
    this.location,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] as Map : const {};
    final shipping = json['shippingAddress'] is Map
        ? json['shippingAddress'] as Map
        : const {};
    final name = "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim();
    final address = [
      shipping['street'],
      shipping['city'],
    ].where((e) => e != null && '$e'.isNotEmpty).join(', ');
    return CustomerModel(
      name: name,
      address: address.isNotEmpty ? address : (user['address'] ?? ''),
      phone: shipping['phone'] ?? user['phone'] ?? '',
      photo: user['photo'] ?? '',
      // Coordinates may live on the shipping address or the user object.
      location:
          LatLngEntity.fromDynamic(shipping) ?? LatLngEntity.fromDynamic(user),
    );
  }

  CustomerEntity toEntity() => CustomerEntity(
    name: name,
    address: address,
    phone: phone,
    photo: photo,
    location: location,
  );
}

class OrderItemModel {
  final String name;
  final String image;
  final num price;
  final int quantity;

  const OrderItemModel({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map ? json['product'] as Map : const {};
    return OrderItemModel(
      name: product['title'] ?? json['name'] ?? '',
      image: product['imgCover'] ?? '',
      price: json['price'] ?? product['price'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }

  OrderItemEntity toEntity() => OrderItemEntity(
    name: name,
    image: image,
    price: price,
    quantity: quantity,
  );
}
