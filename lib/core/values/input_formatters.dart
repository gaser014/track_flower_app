import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  // Egyptian phone number formatter (01xxxxxxxxx)
  static List<TextInputFormatter> get egyptianPhone => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(11),
    _EgyptianPhoneFormatter(),
  ];

  // Username formatter (alphanumeric, underscore, dot)
  static List<TextInputFormatter> get username => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]')),
    LengthLimitingTextInputFormatter(30),
    _NoSpaceFormatter(),
  ];

  // Strong password formatter
  static List<TextInputFormatter> get strongPassword => [
    LengthLimitingTextInputFormatter(50),
    _NoSpaceFormatter(),
  ];

  // Name formatter (Arabic and English letters only)
  static List<TextInputFormatter> get name => [
    FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FFa-zA-Z\s]')),
    LengthLimitingTextInputFormatter(50),
  ];

  // Email formatter
  static List<TextInputFormatter> get email => [
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(100),
  ];

  // Digits only
  static List<TextInputFormatter> digitsOnly({int? maxLength}) => [
    FilteringTextInputFormatter.digitsOnly,
    if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
  ];

  // Decimal numbers
  static List<TextInputFormatter> decimal({int? maxLength}) => [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
    if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
  ];
}

// Egyptian phone formatter (adds space after 4 digits: 0123 4567890)
class _EgyptianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Validate Egyptian phone format (must start with 01)
    if (text.length >= 2 && !text.startsWith('01')) {
      return oldValue;
    }

    return newValue;
  }
}

// No space formatter
class _NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(' ')) {
      return oldValue;
    }
    return newValue;
  }
}
