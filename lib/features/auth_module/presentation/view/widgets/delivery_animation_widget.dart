import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeliveryAnimationWidget extends StatelessWidget {
  const DeliveryAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/Delivery guy (2).json',
      width: double.infinity,
      height: 280,
      fit: BoxFit.contain,
      repeat: true,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 280,
          color: Colors.pink.shade50,
          child: Center(
            child: Text(
              'Animation Error:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}

typedef DeliveryAnimationScreen = DeliveryAnimationWidget;
