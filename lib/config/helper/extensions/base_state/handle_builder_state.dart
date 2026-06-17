import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/base_state/pagination_state.dart';
import 'package:track_flowers_app/config/base_state/state_types.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/cupertino.dart';

extension HandleBuilderState on BaseState {
  Widget? handleBuilderState<T>({
    Widget? onSuccess,
    Widget? onLoading,
    Widget? onEmpty,
    Widget? onError,
  }) {
    switch (state) {
      case BaseStateType.success:
        return onSuccess;
      case BaseStateType.loading:
        return onLoading ??
            Center(
              child: CupertinoActivityIndicator(color: AppColors.primerColor),
            );

      case BaseStateType.error:
        return onError;

      default:
        return null;
    }
  }
}

extension HandleBuilderStateList on PaginationState {
  Widget? handleBuilderStateList<T>({
    Widget? onSuccess,
    Widget? onLoading,
    Widget? onEmpty,
    Widget? onLoadingMore,
    Widget? onError,
  }) {
    switch (state) {
      case PaginationStateType.success:
        return isEmpty ? onEmpty : onSuccess;
      case PaginationStateType.loading:
        return onLoading ??
            Center(
              child: CupertinoActivityIndicator(color: AppColors.primerColor),
            );

      case PaginationStateType.error:
        return onError;
      case PaginationStateType.loadingMore:
        return onLoadingMore ??
            Column(
              spacing: 16,
              children: [
                ?onSuccess,
                Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.primerColor,
                  ),
                ),
                SizedBox(height: 16),
              ],
            );

      default:
        return null;
    }
  }
}
