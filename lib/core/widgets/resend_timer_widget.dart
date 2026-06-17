import 'dart:async';

import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_font_style.dart';
import '../values/app_strings.dart';

class ResendTimerWidget extends StatefulWidget {
  final VoidCallback onResend;
  final int durationInSeconds;

  const ResendTimerWidget({
    super.key,
    required this.onResend,
    this.durationInSeconds = 60,
  });

  @override
  State<ResendTimerWidget> createState() => _ResendTimerWidgetState();
}

class _ResendTimerWidgetState extends State<ResendTimerWidget> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _remainingSeconds = widget.durationInSeconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _handleResend() {
    widget.onResend();
    _startTimer();
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.didntReceiveCode,
          style: AppFontStyle.regular14(
            context: context,
          ).copyWith(color: AppColors.black),
        ),
        const SizedBox(width: 4),
        if (_canResend)
          _ResendButton(onTap: _handleResend)
        else
          _TimerText(time: _formatTime()),
      ],
    );
  }
}

class _ResendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ResendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        AppStrings.resend,
        style: AppFontStyle.regular14(context: context).copyWith(
          color: AppColors.primerColor,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primerColor,
        ),
      ),
    );
  }
}

class _TimerText extends StatelessWidget {
  final String time;

  const _TimerText({required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${AppStrings.resendIn} $time',
      style: AppFontStyle.regular14(
        context: context,
      ).copyWith(color: AppColors.grayA6),
    );
  }
}
