import 'package:cached_network_image/cached_network_image.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    this.fit,
    this.fromApi = true,
    this.colorTint,
    this.blendMode,
    this.isFromSlider = false,
  });

  final double? width, height;
  final String imagePath;
  final BoxFit? fit;
  final Color? colorTint;
  final BlendMode? blendMode;
  final bool fromApi;
  final bool isFromSlider;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.black.withValues(alpha: 0.1),
        ),
        child: Center(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            width: width,
            height: height,
            AppAssets.errorImage,
          ),
        ),
      );
    }

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        colorTint ?? Colors.transparent,
        blendMode ?? BlendMode.dst,
      ),
      child: CachedNetworkImage(
        width: width,
        height: height,

        fit: fit ?? BoxFit.cover,
        imageUrl: imagePath,
        fadeInDuration: const Duration(milliseconds: 300),
        errorListener: (value) {},
        // maxHeightDiskCache: height?.isFinite == true ? height?.toInt() : 512,
        // maxWidthDiskCache: width?.isFinite == true ? width?.toInt() : 512,
        // memCacheHeight: height?.isFinite == true ? height?.toInt() : 512,
        // memCacheWidth: width?.isFinite == true ? width?.toInt() : 512,
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.grayA6.withValues(alpha: 0.25),
          ),
          child: Center(
            child: SvgPicture.asset(
              fit: BoxFit.scaleDown,
              width: width,
              height: height,
              AppAssets.errorImage,
            ),
          ),
        ),
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.black.withValues(alpha: 0.1),
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: AppColors.black,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
