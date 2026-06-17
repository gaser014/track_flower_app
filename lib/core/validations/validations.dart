import 'dart:io';

import '../values/app_strings.dart';

class Validations {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.setPassword1ConditionError;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.setPassword2ConditionError;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.setPassword3ConditionError;
    }

    if (!value.contains(
      RegExp(r'[!@#\$%\^&\*\(\)_\-\+=\[\]\{\};:\,<>\./\\|~`]'),
    )) {
      return AppStrings.setPassword4ConditionError;
    }

    if (value.length < 6 || value.length > 30) {
      return AppStrings.setPassword5ConditionError;
    }

    return null;
  }

  static String? validatePasswordVerification(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPassword;
    } else if (value != password) {
      return AppStrings.confirmPasswordInvalid;
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6 || value.length > 30) {
      return AppStrings.setPassword5ConditionError;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.setPassword1ConditionError;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.setPassword2ConditionError;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.setPassword3ConditionError;
    }
    if (!value.contains(
      RegExp(r'[!@#\$%\^&\*\(\)_\-\+=\[\]\{\};:\,<\>.\\/|~`]'),
    )) {
      return AppStrings.setPassword4ConditionError;
    }
    return null;
  }

  static String? validatePhoneNumber(String? value, int phoneLength) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneRequired;
    } else if (value.length < phoneLength) {
      return AppStrings.phoneInvalid;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameRequired;
    } else {
      return null;
    }
  }

  static String? validatePin(String? value, int length) {
    if (value == null || value.isEmpty) {
      return AppStrings.pinRequired;
    }
    if (value.length != length) {
      return AppStrings.pinInvalid;
    } else {
      return null;
    }
  }

  static String? validateUserImage(File? value) {
    if (value == null) {
      return AppStrings.profileImage;
    } else {
      return null;
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.usernameRequired;
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!usernameRegex.hasMatch(value)) {
      return AppStrings.usernameInvalid;
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    return null;
  }

  static String? validateEgyptianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneRequired;
    }

    if (value.length != 11) {
      return AppStrings.egyptianPhoneInvalid;
    }

    if (!value.startsWith('01')) {
      return AppStrings.egyptianPhoneInvalid;
    }

    return null;
  }
}
