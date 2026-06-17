import 'dart:developer';
import 'package:track_flowers_app/config/api/api_key.dart';
import 'package:track_flowers_app/core/data/data_sources/auth_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthLocalDataSourceContract)
class AuthLocalDataSourceImpl implements AuthLocalDataSourceContract {
  final FlutterSecureStorage fss;

  AuthLocalDataSourceImpl({required this.fss});

  @override
  Future<void> saveUserToken(String token) async {
    try {
      await fss.write(key: APIkeys.accessToken, value: token);
      log("Token saved successfully");
    } catch (e) {
      log("Error saving token: $e");
    }
  }

  @override
  Future<String?> getUserToken() async {
    try {
      return await fss.read(key: APIkeys.accessToken);
    } catch (e) {
      log("Error reading token: $e");
      return null;
    }
  }

  @override
  Future<void> deleteUserToken() async {
    try {
      await fss.delete(key: APIkeys.accessToken);
      log("Token deleted successfully");
    } catch (e) {
      log("Error deleting token: $e");
    }
  }
}
