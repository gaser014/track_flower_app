import 'package:flutter/material.dart';

/// A reusable GridView widget that handles pagination automatically
class PaginationGridView<T> extends StatefulWidget {
  final List<T> items;
  final bool isAlwaysScrollable;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? shimmerBuilder;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final Widget? emptyWidget;
  final int shimmerCount;
  final SliverGridDelegate gridDelegate;

  const PaginationGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRefresh,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    SliverGridDelegate? gridDelegate,
    this.isAlwaysScrollable = false,
    this.shimmerBuilder,
    this.padding,
    this.controller,
    this.emptyWidget,
    this.shimmerCount = 3,
  }) : gridDelegate =
           gridDelegate ??
           const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             childAspectRatio: 0.75,
             crossAxisSpacing: 16,
             mainAxisSpacing: 16,
             mainAxisExtent: 250,
           );

  @override
  State<PaginationGridView<T>> createState() => _PaginationGridViewState<T>();
}

class _PaginationGridViewState<T> extends State<PaginationGridView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildShimmerGrid();
    }

    if (widget.items.isEmpty) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.isAlwaysScrollable
            ? const AlwaysScrollableScrollPhysics()
            : null,
        gridDelegate: widget.gridDelegate,
        itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.items.length) {
            // Show loading indicator for loading more
            return widget.shimmerBuilder?.call(context, index) ??
                const Center(child: CircularProgressIndicator());
          }

          return widget.itemBuilder(context, widget.items[index], index);
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: widget.padding,
      gridDelegate: widget.gridDelegate,
      itemCount: widget.shimmerCount,
      itemBuilder: (context, index) {
        return widget.shimmerBuilder?.call(context, index) ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}
