  import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/api/end_points.dart';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';

part 'auth_module_api_client.g.dart';

  @lazySingleton
  @RestApi(baseUrl: EndPoints.baseUrl)
abstract class AuthModuleApiClient {
  @factoryMethod
  factory AuthModuleApiClient(Dio dio) = _AuthModuleApiClient;

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

  @POST(EndPoints.loginDriver)
  Future<dynamic> loginDriver(
    @Field() String email,
    @Field() String password,
  );
}
