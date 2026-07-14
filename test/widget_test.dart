import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:track_flowers_app/core/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton renders and handles tap correctly', (WidgetTester tester) async {
    bool isTapped = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {
              isTapped = true;
            },
          ),
        ),
      ),
    );

    // Verify that our button is rendered with the correct text.
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    // Verify that the button was tapped.
    expect(isTapped, isTrue);
  });
  
  testWidgets('CustomButton shows loading indicator when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify that the text is not shown when loading.
    expect(find.text('Test Button'), findsNothing);
  });
}
