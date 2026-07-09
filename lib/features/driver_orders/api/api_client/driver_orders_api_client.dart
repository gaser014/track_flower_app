import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';

@lazySingleton
class DriverOrdersApiClient {
  final Dio _dio;
  DriverOrdersApiClient(this._dio);

  Future<OrdersPageModel> getPendingOrders(int page, int limit) async {
    final response = await _dio.get(
      EndPoints.driverPendingOrders,
      queryParameters: {'page': page, 'limit': limit, 'sort': 'createdAt'},
    );
    return OrdersPageModel.fromJson(response.data);
  }

  Future<OrdersPageModel> getMyOrders(int page, int limit) async {
    final response = await _dio.get(
      EndPoints.driverMyOrders,
      queryParameters: {'page': page, 'limit': 200, 'sort': '-createdAt'},
    );
    return OrdersPageModel.fromJson(response.data);
  }

  Future<OrderModel> startOrder(String orderId) async {
    final response = await _dio.put('${EndPoints.startOrder}/$orderId');
    final data =
        response.data['orders'] ?? response.data['order'] ?? response.data;
    return OrderModel.fromJson(data);
  }

  Future<OrderModel> updateOrderState(String orderId, String state) async {
    final response = await _dio.put(
      '${EndPoints.updateOrderState}/$orderId',
      data: {'state': state},
    );
    final data =
        response.data['orders'] ?? response.data['order'] ?? response.data;
    return OrderModel.fromJson(data);
  }
}
