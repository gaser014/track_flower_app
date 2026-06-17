import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../values/app_font_style.dart';

class AuthNavigationLink extends StatelessWidget {
  final String title;
  final String actionTitle;
  final void Function()? action;

  const AuthNavigationLink({
    super.key,
    required this.title,
    required this.actionTitle,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text.rich(
      TextSpan(
        text: title,
        style: AppFontStyle.regular14(
          context: context,
        ).copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: actionTitle,
            style: AppFontStyle.semiBold14(context: context).copyWith(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = action,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
