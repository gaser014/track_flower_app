import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository.dart';

@Injectable()
class GetVehiclesUseCase extends UseCase<VehicleResponseModel, NoParams> {
  final AuthModuleRepository _repository;

  const GetVehiclesUseCase(this._repository);

  @override
  Future<Result<VehicleResponseModel>> call(NoParams params) async {
    return await _repository.getVehicles();
  }
}
