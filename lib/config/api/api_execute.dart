import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/error_handling/failures.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../base_response/result.dart';
import '../dependency_injection/di.dart';

Future<Result<T>> executeApi<T>(Future<T> Function() apiCall) async {
  try {
    final internet = getIt.get<InternetConnection>();
    log("Checking internet connection...");
    log("Internet connection status: ${await internet.hasInternetAccess}");
    final hasInternet = await internet.hasInternetAccess;
    if (!hasInternet) {
      return Error(
        exception: NetworkFailures(errorMessage: AppStrings.noInternet),
      );
    }
  } catch (e) {
    log("Error checking internet connection: $e");
  }

  try {
    var result = await apiCall();
    return Success<T>(data: result);
  } on DioException catch (ex) {
    return Error<T>(
      exception: ServerFailure.fromDioException(dioException: ex),
    );
  } on Exception catch (ex) {
    return Error<T>(exception: ex);
  }
}
