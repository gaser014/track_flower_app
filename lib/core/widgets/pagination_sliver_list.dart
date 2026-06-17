import 'package:track_flowers_app/config/base_state/pagination_state.dart';
import 'package:track_flowers_app/core/widgets/loading_indicator.dart';
import 'package:track_flowers_app/core/widgets/pagination_sliver_builder.dart';
import 'package:flutter/material.dart';

typedef SliverItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);
typedef LoadMoreCallback = void Function();

class PaginationSliverList<T> extends StatefulWidget {
  final PaginationState<T> state;
  final SliverItemBuilder<T> itemBuilder;
  final LoadMoreCallback? onLoadMore;
  final Widget? loadingWidget;
  final Widget? loadingMoreWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final double loadMoreThreshold;

  const PaginationSliverList({
    super.key,
    required this.state,
    required this.itemBuilder,
    this.onLoadMore,
    this.loadingWidget,
    this.loadingMoreWidget,
    this.emptyWidget,
    this.errorWidget,
    this.loadMoreThreshold = 200,
  });

  @override
  State<PaginationSliverList<T>> createState() =>
      _PaginationSliverListState<T>();
}

class _PaginationSliverListState<T> extends State<PaginationSliverList<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      initial: () =>
          _PaginationSliverLoadingWidget(widget: widget.loadingWidget),
      loading: () =>
          _PaginationSliverLoadingWidget(widget: widget.loadingWidget),
      loadingMore: (data) => _PaginationSliverDataWidget(
        data: data,
        itemBuilder: widget.itemBuilder,
        loadingMoreWidget: widget.loadingMoreWidget ?? widget.loadingWidget,
        isLoadingMore: true,
        hasMore: widget.state.hasMore,
      ),
      success: (data, meta) {
        if (data.isEmpty) {
          return _PaginationSliverEmptyWidget(widget: widget.emptyWidget);
        }
        return _PaginationSliverDataWidget(
          data: data,
          itemBuilder: widget.itemBuilder,
          loadingMoreWidget: widget.loadingMoreWidget,
          hasMore: widget.state.hasMore,
        );
      },
      error: (exception) => _PaginationSliverErrorWidget(
        widget: widget.errorWidget,
        exception: exception,
      ),
      errorMore: (data, exception) => _PaginationSliverDataWidget(
        data: data,
        itemBuilder: widget.itemBuilder,
        loadingMoreWidget: widget.loadingMoreWidget,
        hasMore: widget.state.hasMore,
      ),
    );
  }
}

class _PaginationSliverLoadingWidget extends StatelessWidget {
  final Widget? widget;

  const _PaginationSliverLoadingWidget({this.widget});

  @override
  Widget build(BuildContext context) {
    if (widget != null) {
      return widget!;
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: const CenteredLoadingIndicator(),
    );
  }
}

class _PaginationSliverEmptyWidget extends StatelessWidget {
  final Widget? widget;

  const _PaginationSliverEmptyWidget({this.widget});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: widget ?? const Center(child: Text('No items found')),
    );
  }
}

class _PaginationSliverErrorWidget extends StatelessWidget {
  final Widget? widget;
  final Exception exception;

  const _PaginationSliverErrorWidget({this.widget, required this.exception});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: widget ?? Center(child: Text('Error: ${exception.toString()}')),
    );
  }
}

class _PaginationSliverDataWidget<T> extends StatelessWidget {
  final List<T> data;
  final SliverItemBuilder<T> itemBuilder;
  final Widget? loadingMoreWidget;
  final bool isLoadingMore;
  final bool hasMore;

  const _PaginationSliverDataWidget({
    required this.data,
    required this.itemBuilder,
    this.loadingMoreWidget,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return PaginationSliverBuilder<T>(
      data: data,
      itemBuilder: itemBuilder,
      loadingMoreWidget: loadingMoreWidget ?? const PaddedLoadingIndicator(),
      isLoadingMore: isLoadingMore,
      hasMore: hasMore,
    );
  }
}
