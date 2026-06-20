  import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_module_api_client.g.dart';

  @lazySingleton
  @RestApi(baseUrl: EndPoints.baseUrl)
abstract class AuthModuleApiClient {
  @factoryMethod
  factory AuthModuleApiClient(Dio dio) = _AuthModuleApiClient;

  @POST(EndPoints.loginDriver)
  Future<dynamic> loginDriver(
    @Field() String email,
    @Field() String password,
  );
}
