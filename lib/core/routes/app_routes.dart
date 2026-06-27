import 'dart:io';

import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/core/data/data_sources/auth_local_data_source.dart';
import 'package:track_flowers_app/core/routes/routes.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/apply_page.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/apply_success_page.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/forget_password_page.dart';
import 'package:track_flowers_app/features/login/presentation/view/pages/login_page.dart';
import 'package:track_flowers_app/features/spalsh/splash_page.dart';
import 'package:track_flowers_app/features/main/presentation/screens/main_view.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/view/pages/order_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/application_submitted_page.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/onboarding_driver_page.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view/pages/profile_page.dart';

import 'package:go_router/go_router.dart';
import 'package:track_flowers_app/features/tracking_test/presentation/pages/tracking_test_page.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

enum AnimationType {
  fade,
  slide,
  scale,
  rotation,
  slideFromBottom,
  slideFromTop,
  slideFromLeft,
  slideFromRight,
  cupertino,
}

Page<T> buildAnimatedPage<T extends Object?>({
  required Widget child,
  required LocalKey key,
  AnimationType animationType = AnimationType.fade,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeInOut,
}) {
  if (Platform.isIOS && animationType == AnimationType.cupertino) {
    return CupertinoPage<T>(key: key, child: child);
  }

  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _getAnimationTransition(
        animationType,
        animation,
        secondaryAnimation,
        child,
        curve,
      );
    },
  );
}

Widget _getAnimationTransition(
  AnimationType type,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
  Curve curve,
) {
  final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

  switch (type) {
    case AnimationType.fade:
      return FadeTransition(opacity: curvedAnimation, child: child);

    case AnimationType.slide:
    case AnimationType.slideFromRight:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case AnimationType.slideFromLeft:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case AnimationType.slideFromBottom:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case AnimationType.slideFromTop:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case AnimationType.scale:
      return ScaleTransition(
        scale: curvedAnimation,
        child: FadeTransition(opacity: curvedAnimation, child: child),
      );

    case AnimationType.rotation:
      return RotationTransition(
        turns: curvedAnimation,
        child: FadeTransition(opacity: curvedAnimation, child: child),
      );

    case AnimationType.cupertino:
      return FadeTransition(opacity: curvedAnimation, child: child);
  }
}

class CustomTransitionPage<T> extends Page<T> {
  const CustomTransitionPage({
    required this.child,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.transitionsBuilder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final RouteTransitionsBuilder? transitionsBuilder;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedPageRoute<T>(
      page: this,
      transitionsBuilder: transitionsBuilder,
    );
  }
}

class _PageBasedPageRoute<T> extends PageRoute<T> {
  _PageBasedPageRoute({
    required CustomTransitionPage<T> page,
    this.transitionsBuilder,
  }) : super(settings: page);

  CustomTransitionPage<T> get _page => settings as CustomTransitionPage<T>;
  final RouteTransitionsBuilder? transitionsBuilder;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _page.child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return transitionsBuilder?.call(
          context,
          animation,
          secondaryAnimation,
          child,
        ) ??
        FadeTransition(opacity: animation, child: child);
  }
}

abstract class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.applicationSubmitted,
        name: Routes.applicationSubmitted,
        builder: (BuildContext context, GoRouterState state) {
          return const ApplicationSubmittedPage();
        },
      ),
      GoRoute(
        path: Routes.main,
        pageBuilder: (context, state) => buildAnimatedPage(
          key: state.pageKey,
          child: const MainView(),
          animationType: AnimationType.fade,
        ),
        routes: [
          GoRoute(
            path: Routes.orderDetails,
            name: Routes.orderDetails,
            pageBuilder: (context, state) {
              final order = state.extra as OrderEntity?;
              return buildAnimatedPage(
                key: state.pageKey,
                child: order == null
                    ? const MainView()
                    : OrderDetailsPage(order: order),
                animationType: AnimationType.slideFromRight,
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: Routes.splash,
        name: Routes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return SplashPage();
        },
      ),
      GoRoute(
        path: Routes.forgetPassword,
        name: Routes.forgetPassword,
        builder: (BuildContext context, GoRouterState state) {
          return ForgetPasswordPage();
        },
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: Routes.testTracking,
        name: Routes.testTracking,
        builder: (BuildContext context, GoRouterState state) {
          return TrackingTestPage();
        },
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (BuildContext context, GoRouterState state) {
          return ApplyPage();
        },
      ),
      GoRoute(
        path: Routes.applySuccess,
        name: Routes.applySuccess,
        builder: (BuildContext context, GoRouterState state) {
          return ApplySuccessPage();
        },
      ),
      GoRoute(
        path: Routes.home,
        name: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const MainView();
        },
      ),

      GoRoute(
        path: Routes.onboardingDriver,
        name: Routes.onboardingDriver,
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingDriverPage();
        },
      ),

      // GoRoute(
      //   path: Routes.profile,
      //   name: Routes.profile,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const MainProfilePage();
      //   },
      // ),
    ],
    redirect: (context, state) async {
      final currentLocation = state.matchedLocation;

      final authRoutes = [
        Routes.login,
        // Routes.main,
        // // Routes.register,
        // Routes.forgetPassword,
        // Routes.resetPassword,
        // AuthRoutes.otpVerification,
        // AuthRoutes.completeProfile,
        // AuthRoutes.success,
      ];
      //
      // if (!isLoggedIn && !authRoutes.contains(currentLocation)) {
      //   // Redirect to account type selection (start of auth flow)
      //   return Routes.login;
      // }

      if (authRoutes.contains(currentLocation)) {
        final token = await getIt<AuthLocalDataSourceContract>().getUserToken();
        final isLoggedIn = token != null && token.isNotEmpty;

        // Redirect to home screen
        if (isLoggedIn) {
          return Routes.main;
        }
      }

      // No redirect needed
      return null;
    },
  );
}
