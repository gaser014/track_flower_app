import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';

part 'driver_orders_api_client.g.dart';

@Injectable()
@RestApi()
abstract class DriverOrdersApiClient {
  @factoryMethod
  factory DriverOrdersApiClient(Dio dio) = _DriverOrdersApiClient;

  @GET(EndPoints.driverPendingOrders)
  Future<OrdersPageModel> getPendingOrders(@Queries() PaginationParams params);

  @GET(EndPoints.driverMyOrders)
  Future<OrdersPageModel> getMyOrders(@Queries() PaginationParams params);

  @PUT('${EndPoints.startOrder}/{orderId}')
  Future<OrderModel> startOrder(@Path('orderId') String orderId);

  @PUT('${EndPoints.updateOrderState}/{orderId}')
  Future<OrderModel> updateOrderState(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );
}
