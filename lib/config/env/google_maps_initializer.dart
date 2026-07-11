import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:track_flowers_app/config/env/app_env.dart';

/// Bridges the Google Maps key from `.env` to the native map SDK.
///
/// * Android reads the key from `.env` at build time (Gradle injects it into
///   the manifest), so nothing is needed at runtime.
/// * iOS receives the key here via a method channel and calls
///   `GMSServices.provideAPIKey`, keeping `.env` the single source of truth.
abstract class GoogleMapsInitializer {
  static const MethodChannel _channel = MethodChannel('app/google_maps');

  static Future<void> configureIfNeeded() async {
    if (!Platform.isIOS) return;

    final key = AppEnv.googleMapsKey;
    if (key.isEmpty) {
      log('Google Maps key missing in .env', name: 'GoogleMapsInitializer');
      return;
    }

    try {
      await _channel.invokeMethod<void>('setApiKey', key);
    } catch (e) {
      log('Failed to set iOS Google Maps key: $e',
          name: 'GoogleMapsInitializer');
    }
  }
}
