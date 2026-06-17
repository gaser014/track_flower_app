import 'package:flutter/material.dart';

import '../../validations/validations.dart';
import '../../values/app_strings.dart';
import '../../values/input_formatters.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const PhoneField({
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
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: AppInputFormatters.egyptianPhone,
      validator: validator ?? Validations.validateEgyptianPhone,
      onFieldSubmitted: onFieldSubmitted,
      autofillHints: const [AutofillHints.telephoneNumber],
      maxLength: 11,
      decoration: InputDecoration(
        labelText: AppStrings.phoneNumber,
        hintText: AppStrings.enterPhoneNumber,
        prefixText: '+20 ',
      ),
    );
  }
}
