import 'package:flutter/material.dart';

typedef SliverItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

class PaginationSliverBuilder<T> extends StatelessWidget {
  final List<T> data;
  final SliverItemBuilder<T> itemBuilder;
  final Widget? loadingMoreWidget;
  final bool isLoadingMore;
  final bool hasMore;

  const PaginationSliverBuilder({
    super.key,
    required this.data,
    required this.itemBuilder,
    this.loadingMoreWidget,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = data.length + (isLoadingMore || hasMore ? 1 : 0);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < data.length) {
          return itemBuilder(context, data[index], index);
        }

        if (isLoadingMore && loadingMoreWidget != null) {
          return loadingMoreWidget!;
        }

        return const SizedBox.shrink();
      }, childCount: itemCount),
    );
  }
}
