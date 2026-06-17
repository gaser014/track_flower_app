// TODO: data LoginLocalDataSourceContract
import 'package:track_flowers_app/features/login/data/models/user_model.dart';

abstract interface class LoginLocalDataSourceContract {
  Future<UserModel> saveUser(UserModel userModel);
  Future<UserModel?> getUser();
}
