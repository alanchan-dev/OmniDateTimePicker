import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

void main() {
  group('OmniDateTimePicker Basic Tests', () {
    testWidgets('renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OmniDateTimePicker(
              onDateTimeChanged: (dateTime) {},
            ),
          ),
        ),
      );

      expect(find.byType(OmniDateTimePicker), findsOneWidget);
    });

    testWidgets('accepts initial date', (WidgetTester tester) async {
      final initialDate = DateTime(2024, 6, 15, 10, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OmniDateTimePicker(
              initialDate: initialDate,
              onDateTimeChanged: (dateTime) {},
            ),
          ),
        ),
      );

      expect(find.byType(OmniDateTimePicker), findsOneWidget);
    });

    testWidgets('handles different picker types', (WidgetTester tester) async {
      for (final type in OmniDateTimePickerType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OmniDateTimePicker(
                type: type,
                onDateTimeChanged: (dateTime) {},
              ),
            ),
          ),
        );

        expect(find.byType(OmniDateTimePicker), findsOneWidget);

        await tester.pumpWidget(Container());
      }
    });

    testWidgets('respects date constraints', (WidgetTester tester) async {
      final firstDate = DateTime(2024, 1, 1);
      final lastDate = DateTime(2024, 12, 31);
      final initialDate = DateTime(2024, 6, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OmniDateTimePicker(
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateTimeChanged: (dateTime) {},
            ),
          ),
        ),
      );

      expect(find.byType(OmniDateTimePicker), findsOneWidget);
    });
  });
}
