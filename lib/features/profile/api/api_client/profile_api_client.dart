import 'dart:io';

import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/profile/data/models/profile_data_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/data/models/upload_photo_response_model.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/error_logger.dart';

part 'profile_api_client.g.dart';

@Injectable()
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(EndPoints.profileData)
  Future<ProfileDataResponseModel> getProfileData();

  @PUT(EndPoints.editUserProfile)
  Future<ProfileDataResponseModel> editProfile(
    @Body() EditProfileRequestModel request,
  );

  @PUT(EndPoints.updateProfilePhoto)
  @MultiPart()
  Future<UploadPhotoResponseModel> uploadProfilePhoto(
    @Part(name: "photo") File photo,
  );

  @DELETE(EndPoints.logout)
  Future<void> logout();

  @PUT(EndPoints.driversResetPassword)
  Future<void> changePassword(
    @Body() ChangePasswordRequestModel request,
  );
}
