// This is a basic Flutter widget test for the stylish calculator.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:stylish_calculator/main.dart';

void main() {
  testWidgets('Calculator displays initial value of 0',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that calculator starts with 0.
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('Calculator shows number buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that all number buttons are present.
    for (int i = 0; i <= 9; i++) {
      expect(find.text('$i'), findsWidgets);
    }
  });

  testWidgets('Calculator shows operator buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that operator buttons are present.
    expect(find.text('+'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    expect(find.text('×'), findsOneWidget);
    expect(find.text('÷'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('Calculator can perform addition', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap 5
    await tester.tap(find.text('5'));
    await tester.pump();

    // Tap +
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap 3
    await tester.tap(find.text('3'));
    await tester.pump();

    // Tap =
    await tester.tap(find.text('='));
    await tester.pump();

    // Verify result is 8.
    expect(find.text('8'), findsWidgets);
  });

  testWidgets('Calculator clear button works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap 9
    await tester.tap(find.text('9'));
    await tester.pump();

    // Verify 9 is shown.
    expect(find.text('9'), findsWidgets);

    // Tap C to clear.
    await tester.tap(find.text('C'));
    await tester.pump();

    // Verify display shows 0.
    expect(find.text('0'), findsWidgets);
  });
}
