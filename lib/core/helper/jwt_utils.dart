import 'dart:convert';

class JwtUtils {
  static Map<String, dynamic> decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid token: Should have 3 parts');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);

      if (payloadMap is! Map<String, dynamic>) {
        throw const FormatException('Invalid payload: Not a JSON object');
      }

      return payloadMap;
    } catch (e) {
      throw FormatException('Error decoding token: $e');
    }
  }
  static T? getClaim<T>(String token, String claim) {
    try {
      final payload = decodeToken(token);
      return payload[claim] as T?;
    } catch (_) {
      return null;
    }
  }
}
