import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/config/api/end_points.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
class AuthModuleApiClient {}
