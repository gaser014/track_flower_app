import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:flutter/material.dart';

import '../../validations/validations.dart';
import '../../values/app_strings.dart';
import '../../values/input_formatters.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const EmailField({
    super.key,
    required this.controller,
    this.validator,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      inputFormatters: AppInputFormatters.email,
      validator: validator ?? Validations.validateEmail,
      onFieldSubmitted: onFieldSubmitted,
      autofillHints: const [AutofillHints.email],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: AppStrings.email,
        hintText: AppStrings.enterEmail,
        hintStyle: AppFontStyle.regular14().copyWith(color: AppColors.grayA6),
      ),
    );
  }
}
