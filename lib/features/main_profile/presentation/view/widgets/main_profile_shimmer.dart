import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/widgets/custom_shimmer_container.dart';

class MainProfileShimmer extends StatelessWidget {
  const MainProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Avatar Shimmer
          const CustomShimmerContainer(
            height: 100,
            width: 100,
            borderRadius: 50,
          ),
          const SizedBox(height: 16),
          // Name Shimmer
          const CustomShimmerContainer(height: 24, width: 150, borderRadius: 4),
          const SizedBox(height: 8),
          // Email Shimmer
          const CustomShimmerContainer(height: 16, width: 200, borderRadius: 4),
          const SizedBox(height: 24),

          // Menu Items Shimmer
          ...List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  const CustomShimmerContainer(
                    height: 24,
                    width: 24,
                    borderRadius: 12,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: CustomShimmerContainer(
                      height: 16,
                      width: double.infinity,
                      borderRadius: 4,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CustomShimmerContainer(
                    height: 24,
                    width: 24,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
