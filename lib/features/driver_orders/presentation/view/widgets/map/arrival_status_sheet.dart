import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_route_entity.dart';

/// Shows the arrival popup once the driver reaches the destination.
///
/// Returns `true` when the driver confirms the status update, so the caller can
/// pop back and advance the order via [DriverOrdersCubit].
Future<bool?> showArrivalStatusSheet(
  BuildContext context, {
  required OrderEntity order,
  required RouteMode mode,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ArrivalStatusSheet(order: order, mode: mode),
  );
}

class _ArrivalStatusSheet extends StatelessWidget {
  const _ArrivalStatusSheet({required this.order, required this.mode});

  final OrderEntity order;
  final RouteMode mode;

  String get _message => mode == RouteMode.pickup
      ? AppStrings.arrivedAtPickupMessage
      : AppStrings.arrivedAtUserMessage;

  String get _confirmLabel {
    final action = order.status.ui.actionLabel;
    return action.isNotEmpty ? action : AppStrings.updateStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteF9,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              const Gap(20),
              _buildIcon(),
              const Gap(16),
              _buildTitle(context),
              const Gap(8),
              _buildMessage(context),
              const Gap(24),
              _buildConfirmButton(context),
              const Gap(8),
              _buildDismissButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 65,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.gray10,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildIcon() {
    return const CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.primerColor,
      child: Icon(Icons.location_on, color: AppColors.white, size: 36),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppStrings.arrivedTitle,
      textAlign: TextAlign.center,
      style: AppFontStyle.bold20(context: context),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      _message,
      textAlign: TextAlign.center,
      style: AppFontStyle.regular14(
        context: context,
      ).copyWith(color: AppColors.gray53),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primerColor,
          foregroundColor: AppColors.whiteF9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          _confirmLabel,
          style: AppFontStyle.semiBold16(
            context: context,
          ).copyWith(color: AppColors.whiteF9),
        ),
      ),
    );
  }

  Widget _buildDismissButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: Text(
        AppStrings.notNow,
        style: AppFontStyle.medium14(
          context: context,
        ).copyWith(color: AppColors.gray53),
      ),
    );
  }
}
