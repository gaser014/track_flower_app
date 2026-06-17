import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:flutter/material.dart';
import '../../validations/validations.dart';
import '../../values/app_strings.dart';
import '../../values/input_formatters.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function()? toggleVisibility;
  final String? labelText;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  const PasswordField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.hintStyle,
    this.labelStyle,
    this.textInputAction,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.labelText,
    this.toggleVisibility,
    this.obscureText = true,
    this.focusNode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool isObscure;
  @override
  void initState() {
    isObscure = widget.obscureText;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PasswordField oldWidget) {
    if (oldWidget.obscureText != widget.obscureText) {
      isObscure = widget.obscureText;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      keyboardType: TextInputType.visiblePassword,
      obscuringCharacter: '★',
      autovalidateMode: AutovalidateMode.onUserInteraction,

      textInputAction: widget.textInputAction ?? TextInputAction.done,
      inputFormatters: AppInputFormatters.strongPassword,
      validator: widget.validator ?? Validations.validateLoginPassword,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: const [AutofillHints.password],
      style: widget.obscureText
          ? const TextStyle(letterSpacing: 2, color: AppColors.grayA6)
          : null,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText ?? AppStrings.password,
        hintText: AppStrings.passwordHint,
        hintStyle: AppFontStyle.regular14().copyWith(color: AppColors.grayA6),
      ),
    );
  }
}
