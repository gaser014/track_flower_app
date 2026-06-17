import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:flutter/material.dart';

extension ShowErrorMessage on BuildContext {
  void showErrorMessage(BaseState state) {
    if (state.isError) {
      CustomToast.showError(
        context: this,
        message: state.exception?.toString() ?? AppStrings.somethingWentWrong,
      );
    }
  }
}
