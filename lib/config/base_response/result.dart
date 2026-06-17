import 'dart:developer';

import 'package:flutter/foundation.dart';

sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T? data) success,
    required R Function(Exception? exception) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Error<T>) {
      return error((this as Error<T>).exception);
    } else {
      return error(Exception("Unhandled ApiResult case"));
    }
  }

  Result<E> makeDummyData<E>({
    E? dummyData,
    required Result<E> Function(T? data) success,
    required Result<E> Function(Exception? exception) error,
  }) {
    if (kDebugMode && this is Error<T> && dummyData != null) {
      final errorResult = this as Error<T>;
      log("Result error: ${errorResult.exception.toString()}");
      return Success(data: dummyData);
    }
    return when(success: success, error: error);
  }
}

class Success<T> extends Result<T> {
  final T? data;

  const Success({this.data});
}

class Error<T> extends Result<T> {
  final Exception? exception;

  const Error({this.exception});
}
