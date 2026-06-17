import 'package:track_flowers_app/config/base_state/pagination_state.dart';
import 'package:track_flowers_app/core/widgets/loading_indicator.dart';
import 'package:track_flowers_app/core/widgets/pagination_list_builder.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);
typedef LoadMoreCallback = void Function();
typedef RefreshCallback = Future<void> Function();

class PaginationListView<T> extends StatefulWidget {
  final PaginationState<T> state;
  final ItemBuilder<T> itemBuilder;
  final LoadMoreCallback onLoadMore;
  final RefreshCallback? onRefresh;
  final Widget? loadingWidget;
  final Widget? loadingMoreWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? padding;
  final double loadMoreThreshold;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;

  const PaginationListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.onLoadMore,
    this.onRefresh,
    this.loadingWidget,
    this.loadingMoreWidget,
    this.emptyWidget,
    this.errorWidget,
    this.padding,
    this.loadMoreThreshold = 200,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
  });

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PaginationListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _scrollController.removeListener(_onScroll);
      _scrollController = widget.controller ?? ScrollController();
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final threshold =
        _scrollController.position.maxScrollExtent - widget.loadMoreThreshold;
    final currentPosition = _scrollController.position.pixels;

    if (currentPosition >= threshold &&
        widget.state.canLoadMore &&
        !_isLoadingMore) {
      _isLoadingMore = true;
      widget.onLoadMore();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.state.when(
      initial: () => _PaginationLoadingWidget(widget: widget.loadingWidget),
      loading: () => _PaginationLoadingWidget(
        widget: widget.loadingWidget,
        padding: widget.padding,
      ),
      loadingMore: (data) => _PaginationListWidget(
        data: data,
        itemBuilder: widget.itemBuilder,
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        loadingMoreWidget: widget.loadingMoreWidget ?? widget.loadingWidget,
        isLoadingMore: true,
        hasMore: widget.state.hasMore,
      ),
      success: (data, meta) {
        if (data.isEmpty) {
          return _PaginationEmptyWidget(widget: widget.emptyWidget);
        }
        return _PaginationListWidget(
          data: data,
          itemBuilder: widget.itemBuilder,
          controller: _scrollController,
          padding: widget.padding,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          loadingMoreWidget: widget.loadingMoreWidget,
          hasMore: widget.state.hasMore,
        );
      },
      error: (exception) => _PaginationErrorWidget(
        widget: widget.errorWidget,
        exception: exception,
      ),
      errorMore: (data, exception) => _PaginationListWidget(
        data: data,
        itemBuilder: widget.itemBuilder,
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        loadingMoreWidget: widget.loadingMoreWidget,
        hasMore: widget.state.hasMore,
      ),
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: content);
    }

    return content;
  }
}

class _PaginationLoadingWidget extends StatelessWidget {
  final Widget? widget;
  final EdgeInsetsGeometry? padding;

  const _PaginationLoadingWidget({this.widget, this.padding});

  @override
  Widget build(BuildContext context) {
    return widget == null
        ? const CenteredLoadingIndicator()
        : padding == null
        ? widget!
        : Padding(padding: padding!, child: widget!);
  }
}

class _PaginationEmptyWidget extends StatelessWidget {
  final Widget? widget;

  const _PaginationEmptyWidget({this.widget});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(child: widget ?? const Text('No items found')),
      ),
    );
  }
}

class _PaginationErrorWidget extends StatelessWidget {
  final Widget? widget;
  final Exception exception;

  const _PaginationErrorWidget({this.widget, required this.exception});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(child: widget ?? Text('Error: ${exception.toString()}')),
      ),
    );
  }
}

class _PaginationListWidget<T> extends StatelessWidget {
  final List<T> data;
  final ItemBuilder<T> itemBuilder;
  final ScrollController controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget? loadingMoreWidget;
  final bool isLoadingMore;
  final bool hasMore;

  const _PaginationListWidget({
    required this.data,
    required this.itemBuilder,
    required this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.loadingMoreWidget,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return PaginationListBuilder<T>(
      data: data,
      itemBuilder: itemBuilder,
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      loadingMoreWidget: loadingMoreWidget ?? const PaddedLoadingIndicator(),
      isLoadingMore: isLoadingMore,
      hasMore: hasMore,
    );
  }
}
