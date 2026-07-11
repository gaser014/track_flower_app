import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/onboarding_driver_page.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/delivery_animation_widget.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/widgets/onboarding_action_buttons.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        home: widget,
      ),
    );
  }

  testWidgets('renders OnboardingDriverPage correctly', (tester) async {
    // act
    await tester.pumpWidget(buildTestableWidget(const OnboardingDriverPage()));

    // Wait for animations to finish
    await tester.pump(const Duration(seconds: 1));

    // assert
    expect(find.byType(OnboardingDriverPage), findsOneWidget);
    expect(find.byType(DeliveryAnimationWidget), findsOneWidget);
    expect(find.byType(OnboardingActionButtons), findsOneWidget);
  });
}
