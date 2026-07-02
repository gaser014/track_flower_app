import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  const AppSharedPreferences._();
  static late SharedPreferences sharedPreferences;

  static Future<void> initialSharedPreference() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      log('SharedPreferences initialized successfully');
    } catch (e, s) {
      log('Error initializing SharedPreferences', error: e, stackTrace: s);
      rethrow;
    }
  }

  static Future<bool> setString({
    required String key,
    required String value,
  }) async {
    try {
      return await sharedPreferences.setString(key, value);
    } catch (e, s) {
      log('Error saving string to shared preferences', error: e, stackTrace: s);
      return false;
    }
  }

  static String? getString({required String key}) {
    try {
      return sharedPreferences.getString(key);
    } catch (e, s) {
      log('Error getting string from shared preferences', error: e, stackTrace: s);
      return null;
    }
  } 

  static Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    try {
      return await sharedPreferences.setBool(key, value);
    } catch (e, s) {
      log('Error saving bool to shared preferences', error: e, stackTrace: s);
      return false;
    }
  }

  static bool? getBool({required String key}) {
    try {
      return sharedPreferences.getBool(key);
    } catch (e, s) {
      log('Error getting bool from shared preferences', error: e, stackTrace: s);
      return null;
    }
  }
  static Future<bool> setInt({required String key, required int value}) async {
    try {
      return await sharedPreferences.setInt(key, value);
    } catch (e, s) {
      log('Error saving int to shared preferences', error: e, stackTrace: s);
      return false;
    }
  } 

  static int? getInt({required String key}) {
    try {
      return sharedPreferences.getInt(key);
    } catch (e, s) {
      log('Error getting int from shared preferences', error: e, stackTrace: s);
      return null;
    }
  }

  /// Remove value
  static Future<bool> remove({required String key}) async {
    try {
      return await sharedPreferences.remove(key);
    } catch (e, s) {
      log('Error removing from shared preferences', error: e, stackTrace: s);
      return false;
    }
  }

  /// Clear all values
  static Future<bool> clear() async {
    try {
      return await sharedPreferences.clear();
    } catch (e, s) {
      log('Error clearing shared preferences', error: e, stackTrace: s);
      return false;
    }
  }

  /// Check if key exists
  static bool containsKey({required String key}) {
    try {
      return sharedPreferences.containsKey(key);
    } catch (e, s) {
      log('Error checking key in shared preferences', error: e, stackTrace: s);
      return false;
    }
  }
}
