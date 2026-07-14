import 'package:dio/dio.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';

sealed class Failures implements Exception {
  final String errorMessage;

  const Failures({required this.errorMessage});

  @override
  String toString() => errorMessage;
}

class ServerFailure extends Failures {
  const ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioException({required DioException dioException}) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errorMessage: AppStrings.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: AppStrings.sendTimeout);

      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: AppStrings.receiveTimeout);
      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: AppStrings.badCertificate);
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          statusCode: dioException.response!.statusCode,
          response: dioException.response!.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure(errorMessage: AppStrings.requestCancelled);
      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: AppStrings.connectionError);
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return ServerFailure(errorMessage: AppStrings.unknownError);
    }
  }

  factory ServerFailure.fromResponse({int? statusCode, dynamic response}) {
    if (statusCode == 400 ||
        statusCode == 401 ||
        statusCode == 422 ||
        statusCode == 409 ||
        statusCode == 424 ||
        statusCode == 404) {
      return ServerFailure(
        errorMessage: response['message'] ?? AppStrings.unknownError,
      );
    } else if (statusCode == 500) {
      return ServerFailure(errorMessage: AppStrings.apiServerError);
    } else if (statusCode == 403) {
      //    Helper.expiredToken();

      // return the server failure instead of throw it
      return ServerFailure(errorMessage: AppStrings.sessionExpired);
    } else {
      return ServerFailure(errorMessage: AppStrings.unknownError);
    }
  }
}

class OfflineFailures extends Failures {
  const OfflineFailures({required super.errorMessage});
}

class CacheFailures extends Failures {
  const CacheFailures({required super.errorMessage});
}

class NetworkFailures extends Failures {
  const NetworkFailures({required super.errorMessage});
}

List<String> connectionErrorsList = [
  AppStrings.connectionError,
  AppStrings.connectionTimeout,
  AppStrings.receiveTimeout,
  AppStrings.sendTimeout,
];
