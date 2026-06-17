import 'package:track_flowers_app/core/values/app_strings.dart';

import '../failures.dart';

String? handleError(Exception? exception) {
  return switch (exception) {
    ServerFailure() => exception.errorMessage,
    OfflineFailures() => exception.errorMessage,
    CacheFailures() => exception.errorMessage,
    _ => AppStrings.unexpectedError,
  };
}

bool handleNetwork(Exception? exception) {
  return switch (exception) {
    ServerFailure()
        when connectionErrorsList.contains(exception.errorMessage) =>
      true,
    NetworkFailures() => true,
    _ => false,
  };
}
