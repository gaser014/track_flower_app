import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class LabeledValueRow extends StatelessWidget {
  const LabeledValueRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFontStyle.medium14(context: context),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppFontStyle.regular14(
              context: context,
            ).copyWith(color: AppColors.gray53),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
