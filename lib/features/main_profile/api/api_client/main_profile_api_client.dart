import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/main_profile/data/models/profile_data_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'main_profile_api_client.g.dart';

@Injectable()
@RestApi()
abstract class MainProfileApiClient {
  @factoryMethod
  factory MainProfileApiClient(Dio dio) = _MainProfileApiClient;

  @GET(EndPoints.profileData)
  Future<ProfileDataResponseModel> getProfileData();
}
