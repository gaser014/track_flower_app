import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/core/widgets/custom_toast.dart';
import 'package:flutter/material.dart';

extension ShowSuccessMessage on BuildContext {
  void showSuccessMessage({
    required BaseState state,
    required String massage,
    void Function()? onSuccess,
  }) {
    if (state.isSuccess) {
      CustomToast.showSuccess(context: this, message: massage);
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }
}
