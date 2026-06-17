import 'package:dio/dio.dart';
import 'package:track_flowers_app/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'app_interceptor.dart';
import 'end_points.dart';

@module
abstract class DioModule {
  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  @singleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        sendTimeout: Duration(seconds: AppConstants.timeout),
        connectTimeout: Duration(seconds: AppConstants.timeout),
      ),
    );
    dio.interceptors.add(AppInterceptors(dio: dio, fss: secureStorage()));
    dio.interceptors.addAll([
      if (kDebugMode)
        PrettyDioLogger(
          request: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          requestHeader: true,
        ),
    ]);
    return dio;
  }

  @lazySingleton
  CancelToken cancelToken() => CancelToken();

  @lazySingleton
  InternetConnection internetConnection() => InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(
        uri: Uri.parse('https://www.google.com'),
        timeout: const Duration(seconds: 3),
      ),
      InternetCheckOption(
        uri: Uri.parse('https://www.cloudflare.com'),
        timeout: const Duration(seconds: 3),
      ),
    ],
    useDefaultOptions: false,
  );
}
