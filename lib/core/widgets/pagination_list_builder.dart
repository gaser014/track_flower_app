import 'package:flutter/material.dart';

typedef ItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

class PaginationListBuilder<T> extends StatelessWidget {
  final List<T> data;
  final ItemBuilder<T> itemBuilder;
  final Widget? loadingMoreWidget;
  final bool isLoadingMore;
  final bool hasMore;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const PaginationListBuilder({
    super.key,
    required this.data,
    required this.itemBuilder,
    this.loadingMoreWidget,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = data.length + (isLoadingMore || hasMore ? 1 : 0);

    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < data.length) {
          return itemBuilder(context, data[index], index);
        }

        if (isLoadingMore && loadingMoreWidget != null) {
          return loadingMoreWidget!;
        }

        return const SizedBox.shrink();
      },
    );
  }
}
