import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_request.dart';
import 'package:track_flowers_app/features/auth_module/data/models/verify_code_request.dart';

part 'auth_module_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract interface class AuthModuleApiClient {
  @factoryMethod
  factory AuthModuleApiClient(Dio dio) => _AuthModuleApiClient(dio);

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
