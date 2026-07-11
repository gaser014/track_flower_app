import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/env/app_env.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/directions_result_model.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/lat_lng_entity.dart';

/// Thin client for the Google Directions API.
///
/// Uses its own [Dio] instance (not the app client) so no auth headers or the
/// backend base URL leak into the Google request. The API key is read from the
/// `.env` file via [AppEnv].
@lazySingleton
class DirectionsApiClient {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  final Dio _dio;

  DirectionsApiClient() : _dio = Dio();

  /// Requests a single driving route between [origin] and [destination].
  ///
  /// Returns an empty [DirectionsResultModel] when the key is missing or the
  /// API does not return `OK`, letting the repository fall back to a free
  /// straight line instead of failing.
  Future<DirectionsResultModel> getRoute({
    required LatLngEntity origin,
    required LatLngEntity destination,
  }) async {
    final key = AppEnv.googleMapsKey;
    if (key.isEmpty) return const DirectionsResultModel(points: []);

    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.lat},${origin.lng}',
        'destination': '${destination.lat},${destination.lng}',
        'mode': 'driving',
        'key': key,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return DirectionsResultModel.fromJson(data);
    }
    return const DirectionsResultModel(points: []);
  }
}
