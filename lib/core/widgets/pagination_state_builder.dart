import 'package:track_flowers_app/config/base_state/pagination_state.dart';
import 'package:track_flowers_app/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class PaginationStateBuilder<T> extends StatelessWidget {
  final PaginationState<T> state;
  final Widget Function(BuildContext context, List<T> data)? onSuccess;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context)? onEmpty;
  final Widget Function(BuildContext context, List<T> data)? onLoadingMore;
  final Widget Function(BuildContext context, Exception exception)? onError;
  final Widget Function(
    BuildContext context,
    List<T> data,
    Exception exception,
  )?
  onErrorMore;
  final Widget Function(BuildContext context)? onInitial;

  const PaginationStateBuilder({
    super.key,
    required this.state,
    this.onSuccess,
    this.onLoading,
    this.onEmpty,
    this.onLoadingMore,
    this.onError,
    this.onErrorMore,
    this.onInitial,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => onInitial?.call(context) ?? const SizedBox.shrink(),
      loading: () =>
          onLoading?.call(context) ?? const CenteredLoadingIndicator(),
      loadingMore: (data) =>
          onLoadingMore?.call(context, data) ??
          onSuccess?.call(context, data) ??
          const SizedBox.shrink(),
      success: (data, meta) {
        if (data.isEmpty) {
          return onEmpty?.call(context) ??
              const Center(child: Text('No data available'));
        }
        return onSuccess?.call(context, data) ?? const SizedBox.shrink();
      },
      error: (exception) =>
          onError?.call(context, exception) ??
          Center(child: Text('Error: ${exception.toString()}')),
      errorMore: (data, exception) =>
          onErrorMore?.call(context, data, exception) ??
          onSuccess?.call(context, data) ??
          const SizedBox.shrink(),
    );
  }
}
