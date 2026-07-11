import 'package:flutter/material.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';

class MainProfileShimmer extends StatefulWidget {
  const MainProfileShimmer({super.key});

  @override
  State<MainProfileShimmer> createState() => _MainProfileShimmerState();
}

class _MainProfileShimmerState extends State<MainProfileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              ...List.generate(5, (_) => _buildMenuItem()),
              const SizedBox(height: 8),
              ...List.generate(3, (_) => _buildMenuItem()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        children: [
          _shimmerBox(width: 72, height: 72, borderRadius: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 160, height: 16, borderRadius: 8),
                const SizedBox(height: 8),
                _shimmerBox(width: 120, height: 12, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
      child: Row(
        children: [
          _shimmerBox(width: 24, height: 24, borderRadius: 4),
          const SizedBox(width: 16),
          Expanded(
            child: _shimmerBox(height: 14, borderRadius: 7),
          ),
          const SizedBox(width: 16),
          _shimmerBox(width: 24, height: 24, borderRadius: 4),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    double? width,
    required double height,
    required double borderRadius,
  }) {
    return Opacity(
      opacity: _animation.value,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grayEA,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
