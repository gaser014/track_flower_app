import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? radius;

  const LoadingIndicator({super.key, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? AppColors.primerColor,
      radius: radius ?? 10,
    );
  }
}

class CenteredLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? radius;

  const CenteredLoadingIndicator({super.key, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator(color: color, radius: radius),
    );
  }
}

class PaddedLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry padding;

  const PaddedLoadingIndicator({
    super.key,
    this.color,
    this.radius,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: LoadingIndicator(color: color, radius: radius),
      ),
    );
  }
}
