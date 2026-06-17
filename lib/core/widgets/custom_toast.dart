import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../values/app_colors.dart';
import '../values/app_font_style.dart';

enum ToastType { success, error, warning, info }

class CustomToast {
  final BuildContext context;
  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
  final ToastificationStyle style;

  CustomToast({
    required this.context,
    required this.message,
    this.title,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
    this.style = ToastificationStyle.fillColored,
  });

  void show() {
    toastification.show(
      context: context,
      type: _getToastificationType(),
      primaryColor: _getPrimaryColor().withValues(alpha: .8),
      style: style,
      title: title != null
          ? Text(
              title!,
              style: AppFontStyle.semiBold14(
                context: context,
              ).copyWith(color: AppColors.white),
            )
          : null,
      description: Text(
        message,
        style: AppFontStyle.regular12(
          context: context,
        ).copyWith(color: AppColors.white),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  ToastificationType _getToastificationType() {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.info:
        return ToastificationType.info;
    }
  }

  Color _getPrimaryColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.green0C;
      case ToastType.error:
        return AppColors.redCC;
      case ToastType.warning:
        return AppColors.waring;
      case ToastType.info:
        return AppColors.primerColor;
    }
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    CustomToast(
      context: context,
      message: message,
      title: title,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 3),
    ).show();
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    CustomToast(
      context: context,
      message: message,
      title: title,
      type: ToastType.error,
      duration: duration ?? const Duration(seconds: 3),
    ).show();
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    CustomToast(
      context: context,
      message: message,
      title: title,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 3),
    ).show();
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    CustomToast(
      context: context,
      message: message,
      title: title,
      type: ToastType.info,
      duration: duration ?? const Duration(seconds: 3),
    ).show();
  }
}
