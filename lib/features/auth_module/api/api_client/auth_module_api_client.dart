import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
part 'auth_module_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract interface class AuthModuleApiClient {
  @factoryMethod
  factory AuthModuleApiClient(Dio dio) => _AuthModuleApiClient(dio);
}
