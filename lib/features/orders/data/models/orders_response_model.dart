import 'package:json_annotation/json_annotation.dart';
import 'package:track_flowers_app/config/base_response/model/meta_dto.dart';

part 'orders_response_model.g.dart';

/// DTO for `GET /orders`.
///
/// NOTE: Field names follow the Elevate flowers API order shape. If the real
/// response uses different keys (e.g. `totalOrderPrice` instead of
/// `totalPrice`), only the `@JsonKey(name: ...)` values below need to change —
/// the rest of the feature maps through entities and stays untouched.
@JsonSerializable()
class OrdersResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final MetaDto? metadata;
  @JsonKey(name: "orders")
  final List<OrderModel>? orders;

  const OrdersResponseModel({this.message, this.metadata, this.orders});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "totalPrice")
  final num? totalPrice;
  @JsonKey(name: "paymentType")
  final String? paymentType;
  @JsonKey(name: "isPaid")
  final bool? isPaid;
  @JsonKey(name: "isDelivered")
  final bool? isDelivered;
  @JsonKey(name: "state")
  final String? state;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "orderItems")
  final List<OrderItemModel>? orderItems;

  const OrderModel({
    this.id,
    this.orderNumber,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  @JsonKey(name: "product")
  final ProductModel? product;
  @JsonKey(name: "price")
  final num? price;
  @JsonKey(name: "quantity")
  final int? quantity;

  const OrderItemModel({this.product, this.price, this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class ProductModel {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "imgCover")
  final String? imgCover;
  @JsonKey(name: "price")
  final num? price;

  const ProductModel({this.id, this.title, this.imgCover, this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
