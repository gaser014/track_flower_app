import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';

abstract class MainProfileRepositoryContract {
  Future<Result<UserEntity>> getProfileData();
}
