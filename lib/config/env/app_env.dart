import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central access point for values loaded from the `.env` file.
///
/// Keeping every environment lookup here means the rest of the app never
/// touches [dotenv] directly and we can sanitise values in one place.
abstract class AppEnv {
  AppEnv._();

  /// Google Maps key used for the Directions API (route drawing) and, on iOS,
  /// pushed to the native SDK.
  ///
  /// The same key is read natively on Android at build time (Gradle reads the
  /// `.env`). Looked up case-insensitively so `google_map_key`,
  /// `Google_Map_key`, etc. all resolve.
  static String get googleMapsKey => _clean(_lookup('google_map_key'));

  /// Case-insensitive lookup against the loaded `.env` entries.
  static String? _lookup(String name) {
    final lower = name.toLowerCase();
    for (final entry in dotenv.env.entries) {
      if (entry.key.toLowerCase() == lower) return entry.value;
    }
    return null;
  }

  /// Removes surrounding single/double quotes and whitespace that can sneak in
  /// from a `.env` value like `Google_Map_key='AIza...'`.
  static String _clean(String? value) {
    if (value == null) return '';
    var result = value.trim();
    if (result.length >= 2) {
      final first = result[0];
      final last = result[result.length - 1];
      if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
        result = result.substring(1, result.length - 1);
      }
    }
    return result.trim();
  }
}
