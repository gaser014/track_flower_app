import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/main_profile/data/datasources/main_profile_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/main_profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MainProfileRepositoryContract)
class MainProfileRepositoryImpl implements MainProfileRepositoryContract {
  final MainProfileRemoteDataSourceContract _remoteDataSource;

  const MainProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> getProfileData() async {
    var response = await _remoteDataSource.getProfileData();
    return response.when(
      success: (data) {
        if (data?.user != null) {
          return Success(data: data!.user!.toUserEntity());
        }
        return Error(exception: Exception("User data is null"));
      },
      error: (exception) => Error(exception: exception),
    );
  }
}
