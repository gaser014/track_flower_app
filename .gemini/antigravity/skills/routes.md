---
name: routes
description: >
  Creates and edits ONLY the routing config files for a Darsy feature, living in
  lib/feature/{feature}/config/: {feature}_routes.dart (path constants), {feature}_navigation_args.dart
  (typed args via Equatable), {feature}_navigation_helper.dart (static go/push helpers), and
  {feature}_router_config.dart (GoRoute list via buildAnimatedPage). Wires the route list into
  lib/core/routes/app_routes.dart. Does NOT create screens, cubits, or data/domain files. Use
  when adding/removing a screen route, adding nav args, or setting up a feature's navigation.
  Trigger on "route", "navigation", "go_router", "عدل الراوت", "اضف شاشة للراوتر", "router config".
---

# Darsy Routing Skill

**Scope:** this skill only touches the four config files under `lib/feature/{feature}/config/`
plus the registration line in `lib/core/routes/app_routes.dart`. It does not build screens,
widgets, cubits, or any data/domain code.

Verified against `lib/feature/auth/config/*`.

---

## Imports you'll use

```dart
import 'package:darsy/config/dependency_injection/di.dart';   // getIt
import 'package:darsy/core/routes/app_routes.dart';           // buildAnimatedPage, AnimationType
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';              // BlocProvider when wrapping a screen
import 'package:go_router/go_router.dart';
import 'package:equatable/equatable.dart';                    // args classes
```

`AnimationType` values (from `app_routes.dart`):
`fade`, `slide`, `scale`, `rotation`, `slideFromBottom`, `slideFromTop`, `slideFromLeft`,
`slideFromRight`, `cupertino`.

`buildAnimatedPage` signature:
```dart
Page<T> buildAnimatedPage<T extends Object?>({
  required Widget child,
  required LocalKey key,
  AnimationType animationType = AnimationType.fade,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeInOut,
});
```

Convention by screen kind:
- drill-down / push → `slideFromRight`
- tab / shell / replace → `fade` or `scale`
- success screens → `scale` (often `curve: Curves.elasticOut`)
- bottom sheets-as-route → `slideFromBottom`

---

## File 1 — `{feature}_routes.dart` (path constants)

- Private constructor `{Feature}Routes._()`.
- Private `_basePath`; all paths build from it.
- For nested `GoRoute`s, expose a `*Segment` (relative) plus the full path.

```dart
class AuthRoutes {
  AuthRoutes._();

  static const String _basePath = '/auth';

  static const String accountTypeSelection = '$_basePath/account-type';

  // nested child: relative segment + full path
  static const String loginSegment = 'login';
  static const String login = '$accountTypeSelection/$loginSegment';

  static const String otpVerification = '$_basePath/otp';
  static const String success = '$_basePath/success';
}
```

> App-level paths (splash, home shells, cross-feature destinations) live in
> `lib/core/routes/app_paths.dart` as `AppPaths.*`. Feature flows use their own `*Routes` class.

---

## File 2 — `{feature}_navigation_args.dart` (typed args)

- One class per screen that needs more than a path param. Extend `Equatable`.
- Compose related args via inheritance (e.g. `TeacherOtpScreenArgs extends OtpScreenArgs`).
- A screen with no args doesn't need a class.

```dart
class OtpScreenArgs extends Equatable {
  final String phoneNumber;
  final AccountType accountType;
  final bool isForgetPassword;

  const OtpScreenArgs({
    required this.phoneNumber,
    required this.accountType,
    required this.isForgetPassword,
  });

  @override
  List<Object?> get props => [phoneNumber, accountType];
}
```

---

## File 3 — `{feature}_navigation_helper.dart` (static helpers)

- `abstract class {Feature}NavigationHelper` with **static** methods only.
- `context.push(...)` to stack a screen, `context.go(...)` to replace the stack.
- Always pass payloads via `extra:` (never query params).
- Include a `navigateBack` guarded by `canPop()`.

```dart
abstract class AuthNavigationHelper {
  static void navigateToLogin(BuildContext context, AccountType type) =>
      context.go(AuthRoutes.login, extra: type);

  static void navigateToOtpVerification(
    BuildContext context, {
    required String phoneNumber,
    required AccountType accountType,
    required bool isForgetPassword,
  }) {
    context.push(
      AuthRoutes.otpVerification,
      extra: OtpScreenArgs(
        phoneNumber: phoneNumber,
        accountType: accountType,
        isForgetPassword: isForgetPassword,
      ),
    );
  }

  static void navigateToSuccess(BuildContext context, UserEntity user) =>
      context.push(AuthRoutes.success, extra: user);

  static void navigateBack(BuildContext context) {
    if (context.canPop()) context.pop();
  }
}
```

> Helper params are usually **named** (except a single obvious positional like `type`/`user`).
> Match the exact signature when calling — mismatched positional/named args is a common error.

---

## File 4 — `{feature}_router_config.dart` (GoRoute list)

- `class {Feature}RouterConfig { {Feature}RouterConfig._(); }`
- `static List<RouteBase> getRoutes()` (method, not a field).
- Every route uses `pageBuilder` + `buildAnimatedPage` (never bare `builder:`).
- Cast `state.extra` to a **nullable** type and validate: `throw ArgumentError(...)` if required.
- Wrap the screen in `BlocProvider(create: (_) => getIt<XCubit>())` when it needs a cubit at route level.

```dart
class AuthRouterConfig {
  AuthRouterConfig._();

  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AuthRoutes.accountTypeSelection,
        name: AuthRoutes.accountTypeSelection,
        pageBuilder: (context, state) => buildAnimatedPage(
          key: state.pageKey,
          child: BlocProvider<AccountTypeSelectionCubit>(
            create: (_) => getIt<AccountTypeSelectionCubit>(),
            child: AccountTypeSelectionScreen(type: state.extra as AccountType?),
          ),
          animationType: AnimationType.fade,
        ),
        routes: [
          // nested child uses the relative *Segment as path, full route as name
          GoRoute(
            path: AuthRoutes.loginSegment,
            name: AuthRoutes.login,
            pageBuilder: (context, state) => buildAnimatedPage(
              key: state.pageKey,
              child: LoginScreen(accountType: state.extra as AccountType?),
              animationType: AnimationType.slideFromRight,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AuthRoutes.otpVerification,
        name: AuthRoutes.otpVerification,
        pageBuilder: (context, state) {
          final args = state.extra as OtpScreenArgs?;
          if (args == null) {
            throw ArgumentError('OtpScreenArgs is required for OTP screen');
          }
          return buildAnimatedPage(
            key: state.pageKey,
            child: OtpVerificationScreen(
              phoneNumber: args.phoneNumber,
              accountType: args.accountType,
              isForgetPassword: args.isForgetPassword,
            ),
            animationType: AnimationType.slideFromRight,
          );
        },
      ),
    ];
  }
}
```

Optional: route-level `redirect:` for guards (e.g. requiring stored data) — see
`auth_router_config.dart` `_requireAccountTypeStored`.

---

## Register in `app_routes.dart`

Add the import and spread the list into the main `GoRouter.routes`:

```dart
import 'package:darsy/feature/{feature}/config/{feature}_router_config.dart';
// ...
routes: [
  // ...existing routes
  ...{Feature}RouterConfig.getRoutes(),
],
```

The router lives in `abstract class AppRoutes { static final GoRouter router = GoRouter(...); }`.

---

## Editing existing routes

**Add a screen to a feature:** (1) add path const to `*_routes.dart`, (2) add args class if needed,
(3) add a helper method, (4) add the `GoRoute` in `*_router_config.dart`. Don't rewrite whole files —
add only what's needed.

**Remove a screen:** reverse the four steps above.

---

## Do / Don't

- ✅ `pageBuilder` + `buildAnimatedPage` for every route. ❌ bare `builder:`.
- ✅ `static List<RouteBase> getRoutes()`. ❌ a mutable `static List routes = [...]` field.
- ✅ Validate `state.extra` and `throw ArgumentError` when required.
- ✅ Add the import in `app_routes.dart` when registering. ❌ forget it (compile error).
- ✅ `extra:` for payloads. ❌ query params for objects.

---

## File map

```
lib/
├── core/routes/
│   ├── app_routes.dart   ← GoRouter + buildAnimatedPage + AnimationType
│   └── app_paths.dart    ← app-level path constants (AppPaths.*)
└── feature/{feature}/config/
    ├── {feature}_routes.dart
    ├── {feature}_navigation_args.dart
    ├── {feature}_navigation_helper.dart
    └── {feature}_router_config.dart
```

**Last verified**: May 2026 against `feature/auth/config/*` and `core/routes/app_routes.dart`.
