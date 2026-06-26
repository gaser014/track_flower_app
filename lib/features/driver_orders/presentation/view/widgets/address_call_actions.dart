import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

class AddressCallActions extends StatelessWidget {
  const AddressCallActions({
    super.key,
    required this.phone,
    this.onCall,
    this.onChat,
  });

  final String phone;
  final VoidCallback? onCall;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionCircleIcon(icon: Icons.call, onTap: onCall),
        const SizedBox(width: 8),
        ActionCircleIcon(icon: Icons.chat_bubble, onTap: onChat),
      ],
    );
  }
}

class ActionCircleIcon extends StatelessWidget {
  const ActionCircleIcon({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Icon(icon, size: 20, color: AppColors.primerColor),
    );
  }
}
