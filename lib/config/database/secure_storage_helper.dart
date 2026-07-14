import 'dart:developer';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Helper
///
class AppSecureStorage {
  const AppSecureStorage._();
  static late FlutterSecureStorage flutterSecureStorage;

  /// Initialize Secure Storage
  static Future<void> initialSecureStorage() async {
    try {
      flutterSecureStorage = getIt<FlutterSecureStorage>();
      log('SecureStorage initialized successfully');
    } catch (e, s) {
      log('Error initializing SecureStorage', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Save String value
  static Future<bool> setString({
    required String key,
    required String value,
  }) async {
    try {
      await flutterSecureStorage.write(key: key, value: value);
      return true;
    } catch (e, s) {
      log('Error saving string to secure storage', error: e, stackTrace: s);
      return false;
    }
  }

  /// Get String value
  static Future<String?> getString({required String key}) async {
    try {
      return await flutterSecureStorage.read(key: key);
    } catch (e, s) {
      log('Error getting string from secure storage', error: e, stackTrace: s);
      return null;
    }
  }

  /// Remove value
  static Future<bool> remove({required String key}) async {
    try {
      await flutterSecureStorage.delete(key: key);
      return true;
    } catch (e, s) {
      log('Error removing from secure storage', error: e, stackTrace: s);
      return false;
    }
  }

  /// Clear all values
  static Future<bool> clear() async {
    try {
      await flutterSecureStorage.deleteAll();
      return true;
    } catch (e, s) {
      log('Error clearing secure storage', error: e, stackTrace: s);
      return false;
    }
  }

  /// Check if key exists
  static Future<bool> containsKey({required String key}) async {
    try {
      final value = await flutterSecureStorage.read(key: key);
      return value != null;
    } catch (e, s) {
      log('Error checking key in secure storage', error: e, stackTrace: s);
      return false;
    }
  }
}
