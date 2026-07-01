import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';

class GenderSelectorWidget extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelectorWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Gender',
          style: AppFontStyle.bold16(context: context)
              .copyWith(color: AppColors.gray7D),
        ),
        const Spacer(),
        _buildRadioButton(context, 'Female'),
        const SizedBox(width: 16),
        _buildRadioButton(context, 'Male'),
      ],
    );
  }

  Widget _buildRadioButton(BuildContext context, String value) {
    final isSelected = selectedGender.toLowerCase() == value.toLowerCase();

    return GestureDetector(
      onTap: () => onGenderChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primerColor : AppColors.black,
                width: isSelected ? 6 : 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppFontStyle.regular16(context: context),
          ),
        ],
      ),
    );
  }
}
