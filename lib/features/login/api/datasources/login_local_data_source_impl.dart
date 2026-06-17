import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/login/data/datasources/login_local_data_source_contract.dart';
import 'package:track_flowers_app/features/login/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

import 'dart:convert';

@Injectable(as: LoginLocalDataSourceContract)
class LoginLocalDataSourceImpl implements LoginLocalDataSourceContract {
  @override
  Future<UserModel> saveUser(UserModel userModel) async {
    await AppSharedPreferences.setString(
      key: AppStrings.user,
      value: jsonEncode(userModel.toJson()),
    );
    return userModel;
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await AppSharedPreferences.getString(key: AppStrings.user);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }
}
