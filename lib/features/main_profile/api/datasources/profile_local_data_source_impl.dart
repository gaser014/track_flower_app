import 'dart:convert';
import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/main_profile/data/datasources/profile_local_data_source_contract.dart';
import 'package:track_flowers_app/features/main_profile/data/models/profile_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileLocalDataSourceContract)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSourceContract {
  @override
  Future<ProfileModel> saveProfile(ProfileModel profileModel) async {
    await AppSharedPreferences.setString(
      key: AppStrings.user,
      value: jsonEncode(profileModel.toJson()),
    );
    return profileModel;
  }

  @override
  Future<ProfileModel?> getProfile() async {
    final profileJson = await AppSharedPreferences.getString(key: AppStrings.user);
    if (profileJson == null) return null;
    return ProfileModel.fromJson(jsonDecode(profileJson));
  }
}
