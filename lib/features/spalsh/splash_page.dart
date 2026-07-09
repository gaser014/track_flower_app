import 'dart:developer';

import 'package:track_flowers_app/config/api/api_key.dart';
import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/core/values/app_assets.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward().then((_) async {
      if (mounted) {
        String? token = await AppSharedPreferences.getString(
          key: APIkeys.accessToken,
        );
        bool remember =
            await AppSharedPreferences.getBool(key: APIkeys.rememberMe) ??
            false;
        log("==" * 50);
        log("Token: $token");
        log("Remember Me: $remember");
        if (mounted) {
          if (token == null || !remember) {
            log(
              "Token is null or remember me is false, navigating to login page",
            );
            context.go(Routes.login);
          } else {
            log(
              "Token is not null and remember me is true, navigating to main page",
            );
            OrderEntity? activeOrder;
            final result = await getIt<GetActiveOrderUseCase>()(
              const NoParams(),
            );
            result.when(
              success: (data) => activeOrder = data,
              error: (_) => activeOrder = null,
            );
            if (!mounted) return;
            if (activeOrder != null) {
              context.go(
                '${Routes.main}/${Routes.orderDetails}',
                extra: activeOrder,
              );
            } else {
              context.go(Routes.main);
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppAssets.logoSplash, fit: BoxFit.cover),
          ),
          // Centered Logo and Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    AppAssets.splashLogo,
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                // Animated Text
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(AppAssets.logoTextSplash, width: 200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
