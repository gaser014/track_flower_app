import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/features/orders/data/models/orders_response_model.dart';
import 'package:track_flowers_app/features/orders/domain/entities/order_entity.dart';

/// DTO -> Entity mapping. Kept in the data layer as extensions so the domain
/// stays free of serialization concerns and every nullable field gets a safe
/// default in one place.
extension OrdersResponseMapper on OrdersResponseModel {
  OrdersPageEntity toEntity() {
    return OrdersPageEntity(
      meta: metadata?.toEntity() ?? const MetaEntity.empty(),
      orders: (orders ?? const [])
          .map((order) => order.toEntity())
          .toList(growable: false),
    );
  }
}

extension OrderMapper on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? "",
      orderNumber: orderNumber ?? "",
      totalPrice: totalPrice ?? 0,
      paymentType: paymentType ?? "",
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state ?? "",
      createdAt: createdAt ?? "",
      items: (orderItems ?? const [])
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

extension OrderItemMapper on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: product?.id ?? "",
      title: product?.title ?? "",
      image: product?.imgCover ?? "",
      price: price ?? product?.price ?? 0,
      quantity: quantity ?? 0,
    );
  }
}
