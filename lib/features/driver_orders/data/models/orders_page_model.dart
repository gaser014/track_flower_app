import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';

class OrdersPageModel {
  final List<OrderModel> orders;
  final MetaEntity meta;

  const OrdersPageModel({required this.orders, required this.meta});

  factory OrdersPageModel.fromJson(dynamic data) {
    if (data is List) {
      return OrdersPageModel(
        orders: data.map((e) => OrderModel.fromJson(e)).toList(),
        meta: const MetaEntity.empty(),
      );
    }

    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : const <String, dynamic>{};
    final rawList = map['orders'] ?? map['data'] ?? const [];
    final orders = (rawList as List? ?? const [])
        .map((e) => OrderModel.fromJson(e))
        .toList();

    final rawMeta = map['metadata'] ?? map['meta'];
    final meta = rawMeta is Map
        ? _metaFromJson(Map<String, dynamic>.from(rawMeta))
        : const MetaEntity.empty();

    return OrdersPageModel(orders: orders, meta: meta);
  }

  static MetaEntity _metaFromJson(Map<String, dynamic> json) {
    return MetaEntity(
      currentPage: _toInt(json['currentPage']) ?? 1,
      numberOfPages:
          _toInt(json['numberOfPages']) ?? _toInt(json['totalPages']) ?? 1,
      limit: _toInt(json['limit']) ?? 20,
      total: _toInt(json['total']) ?? _toInt(json['totalItems']),
    );
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
