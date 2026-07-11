import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';

part 'auth_module_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class AuthModuleApiClient {
  @factoryMethod
  factory AuthModuleApiClient(Dio dio) = _AuthModuleApiClient;

  @POST(EndPoints.login)
  Future<dynamic> loginDriver(@Field() String email, @Field() String password);

  @GET(EndPoints.vehiclesEndpoint)
  Future<VehicleResponseModel> getVehicles();

  @POST(EndPoints.applyDriverEndpoint)
  @MultiPart()
  Future<ApplyResponseModel> applyDriver({
    @Part(name: "country") required String country,
    @Part(name: "firstName") required String firstName,
    @Part(name: "lastName") required String lastName,
    @Part(name: "vehicleType") required String vehicleType,
    @Part(name: "vehicleNumber") required String vehicleNumber,
    @Part(name: "vehicleLicense") required File vehicleLicense,
    @Part(name: "NID") required String nid,
    @Part(name: "NIDImg") required File nidImg,
    @Part(name: "email") required String email,
    @Part(name: "password") required String password,
    @Part(name: "rePassword") required String rePassword,
    @Part(name: "gender") required String gender,
    @Part(name: "phone") required String phone,
  });
  @POST(EndPoints.logoutDriver)
  Future<void> logoutDriver();

  @POST(EndPoints.forgetPasswordEndpoint)
  Future<ForgetPasswordResponse> sendForgetPasswordCode(
    @Body() ForgetPasswordRequest request,
  );

  @POST(EndPoints.verifyResetEndpoint)
  Future<ForgetPasswordResponse> verifyForgetPasswordCode(
    @Body() VerifyCodeRequest request,
  );

  @PUT(EndPoints.resetPasswordEndpoint)
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );
}
