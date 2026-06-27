import 'package:track_flowers_app/features/main_profile/data/models/profile_model.dart';

abstract interface class AuthModuleLocalDataSourceContract {
  Future<ProfileModel> saveProfile(ProfileModel profileModel);
  Future<ProfileModel?> getProfile();
}
