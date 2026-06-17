import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_font_style.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;

  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) _DialogTitle(title: title!),
            if (title != null && (message != null || content != null))
              const SizedBox(height: 16),
            if (message != null) _DialogMessage(message: message!),
            ?content,
            if (onConfirm != null || onCancel != null)
              const SizedBox(height: 24),
            if (onConfirm != null || onCancel != null)
              _DialogActions(
                confirmText: confirmText,
                cancelText: cancelText,
                onConfirm: onConfirm,
                onCancel: onCancel,
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  final String title;

  const _DialogTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppFontStyle.semiBold18(
        context: context,
      ).copyWith(color: AppColors.black),
      textAlign: TextAlign.center,
    );
  }
}

class _DialogMessage extends StatelessWidget {
  final String message;

  const _DialogMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppFontStyle.regular14(
        context: context,
      ).copyWith(color: AppColors.black0C),
      textAlign: TextAlign.center,
    );
  }
}

class _DialogActions extends StatelessWidget {
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const _DialogActions({
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onCancel != null)
          Expanded(
            child: _CancelButton(text: cancelText, onTap: onCancel!),
          ),
        if (onCancel != null && onConfirm != null) const SizedBox(width: 12),
        if (onConfirm != null)
          Expanded(
            child: _ConfirmButton(text: confirmText, onTap: onConfirm!),
          ),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;

  const _ConfirmButton({this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primerColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text ?? 'OK', style: AppFontStyle.medium14(context: context)),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;

  const _CancelButton({this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.black0C,
        side: const BorderSide(color: AppColors.black0C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        text ?? 'Cancel',
        style: AppFontStyle.medium14(context: context),
      ),
    );
  }
}
