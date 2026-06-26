import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/orders/data/models/orders_response_model.dart';

part 'orders_api_client.g.dart';

@Injectable()
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(EndPoints.ordersPage)
  Future<OrdersResponseModel> getOrders(
    @Query("page") int page,
    @Query("limit") int limit,
  );
}
