import 'dart:io';
import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/login/data/models/login_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_client.g.dart';

@Injectable()
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) = _LoginApiClient;
  @POST(EndPoints.login)
  Future<LoginResponseModel> login(
    @Field() String email,
    @Field() String password,
  );

  @GET(EndPoints.getUserProfile)
  Future<LoginResponseModel> getProfile();

  @PUT(EndPoints.editUserProfile)
  Future<LoginResponseModel> editProfile(
    @Body() Map<String, dynamic> body,
  );

  @PUT(EndPoints.uploadPhoto)
  @MultiPart()
  Future<LoginResponseModel> updateProfilePhoto(
    @Part(name: "photo") File file,
  );
}
