import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository.dart';

@Injectable()
class GetCountriesUseCase extends UseCase<List<CountryModel>, NoParams> {
  final AuthModuleRepository _repository;

  const GetCountriesUseCase(this._repository);

  @override
  Future<Result<List<CountryModel>>> call(NoParams params) async {
    return await _repository.getCountries();
  }
}
