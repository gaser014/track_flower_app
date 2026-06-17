import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/main_profile/api/api_client/main_profile_api_client.dart';
import 'package:track_flowers_app/features/main_profile/data/datasources/main_profile_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/main_profile/data/models/profile_data_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MainProfileRemoteDataSourceContract)
class MainProfileRemoteDataSourceImpl
    implements MainProfileRemoteDataSourceContract {
  final MainProfileApiClient _apiClient;

  const MainProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ProfileDataResponseModel>> getProfileData() async {
    return await executeApi(() async {
      final response = await _apiClient.getProfileData();
      return response;
    });
  }
}
