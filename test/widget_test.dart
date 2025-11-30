// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:stylish_calculator/main.dart';

void main() {
  testWidgets('Calculator displays zero on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const StylishCalculatorApp());

    expect(find.text('0'), findsWidgets);
    await tester.tap(find.text('AC'));
    await tester.pump();
    expect(find.text('0'), findsWidgets);
  });
}
