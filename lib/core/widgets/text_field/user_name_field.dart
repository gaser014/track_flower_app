import 'package:flutter/material.dart';

import '../../validations/validations.dart';
import '../../values/app_strings.dart';
import '../../values/input_formatters.dart';

class UserNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const UserNameField({
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
      keyboardType: TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      inputFormatters: AppInputFormatters.username,
      validator: validator ?? Validations.validateUserName,
      onFieldSubmitted: onFieldSubmitted,
      autofillHints: const [AutofillHints.username],
      decoration: InputDecoration(
        labelText: AppStrings.username,
        hintText: AppStrings.enterUserName,
      ),
    );
  }
}
