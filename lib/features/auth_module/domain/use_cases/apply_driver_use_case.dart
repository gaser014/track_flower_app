import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';

@Injectable()
class ApplyDriverUseCase extends UseCase<ApplyResponseModel, ApplyDriverParams> {
  final AuthModuleRepository _repository;

  const ApplyDriverUseCase(this._repository);

  @override
  Future<Result<ApplyResponseModel>> call(ApplyDriverParams params) async {
    return await _repository.applyDriver(
      country: params.country,
      firstName: params.firstName,
      lastName: params.lastName,
      vehicleType: params.vehicleType,
      vehicleNumber: params.vehicleNumber,
      vehicleLicense: params.vehicleLicense,
      nid: params.nid,
      nidImg: params.nidImg,
      email: params.email,
      password: params.password,
      rePassword: params.rePassword,
      gender: params.gender,
      phone: params.phone,
    );
  }
}
