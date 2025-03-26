// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breuninger_test/main.dart';

void main() {
  testWidgets('Main smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the list is diplayed.
    expect(find.text('Index: 0'), findsOneWidget);
    expect(find.text('Index: 1'), findsOneWidget);
    expect(find.text('Index: 2'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the filter icon.
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();

    // Verify that the filter menu is displayed.
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    // Tap the data source icon.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    // Verify that the data source menu is displayed.
    expect(find.text('Simple data source'), findsOneWidget);
    expect(find.text('Complex data source'), findsOneWidget);
  });
}
