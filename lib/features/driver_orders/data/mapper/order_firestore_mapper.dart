import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';

extension OrderFirestoreMapper on OrderEntity {
  Map<String, dynamic> toFirestoreMap({
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? driverPhoto,
    double? driverLat,
    double? driverLng,
  }) {
    final hasDriverLocation = driverLat != null && driverLng != null;

    final driver = <String, dynamic>{
      if (driverId != null && driverId.isNotEmpty) 'id': driverId,
      if (driverName != null && driverName.isNotEmpty) 'name': driverName,
      if (driverPhone != null && driverPhone.isNotEmpty) 'phone': driverPhone,
      if (driverPhoto != null && driverPhoto.isNotEmpty) 'photo': driverPhoto,
      if (hasDriverLocation) 'location': {'lat': driverLat, 'lng': driverLng},
    };

    return {
      'orderId': id,
      'orderNumber': orderNumber,
      'status': status.name,
      'paymentType': paymentMethod == PaymentMethod.cashOnDelivery
          ? 'cash'
          : 'card',
      'totalPrice': totalPrice,
      'store': {
        'name': store.name,
        'address': store.address,
        'phone': store.phone,
      },
      'customer': {
        'name': customer.name,
        'address': customer.address,
        'phone': customer.phone,
      },
      'items': items
          .map(
            (item) => {
              'name': item.name,
              'image': item.image,
              'price': item.price,
              'quantity': item.quantity,
            },
          )
          .toList(growable: false),
      // Structured driver object (new) for consumers that read full info.
      if (driver.isNotEmpty) 'driver': driver,
      // Flat fields kept for backward compatibility with existing consumers.
      if (driverId != null && driverId.isNotEmpty) 'driverId': driverId,
      if (hasDriverLocation)
        'driverLocation': {'lat': driverLat, 'lng': driverLng},
    };
  }
}
