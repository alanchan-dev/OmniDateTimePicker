import 'package:flutter_test/flutter_test.dart';
import 'package:omni_datetime_picker/src/utils/date_time_extensions.dart';

void main() {
  group('DateTime Extensions Tests', () {
    group('IsSameDate Extension', () {
      test('returns true for same date with same time', () {
        final date1 = DateTime(2024, 6, 15, 10, 30, 45);
        final date2 = DateTime(2024, 6, 15, 10, 30, 45);

        expect(date1.isSameDate(date2), isTrue);
      });

      test('returns true for same date with different time', () {
        final date1 = DateTime(2024, 6, 15, 10, 30, 45);
        final date2 = DateTime(2024, 6, 15, 14, 45, 30);

        expect(date1.isSameDate(date2), isTrue);
      });

      test('returns false for different years', () {
        final date1 = DateTime(2024, 6, 15, 10, 30, 45);
        final date2 = DateTime(2023, 6, 15, 10, 30, 45);

        expect(date1.isSameDate(date2), isFalse);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2024, 6, 15, 10, 30, 45);
        final date2 = DateTime(2024, 7, 15, 10, 30, 45);

        expect(date1.isSameDate(date2), isFalse);
      });

      test('returns false for different days', () {
        final date1 = DateTime(2024, 6, 15, 10, 30, 45);
        final date2 = DateTime(2024, 6, 16, 10, 30, 45);

        expect(date1.isSameDate(date2), isFalse);
      });

      test('handles edge cases with timezone differences', () {
        final date1 = DateTime(2024, 6, 15, 23, 59, 59);
        final date2 = DateTime(2024, 6, 15, 0, 0, 1);

        expect(date1.isSameDate(date2), isTrue);
      });

      test('handles leap year dates', () {
        final date1 = DateTime(2024, 2, 29, 10, 30); // Leap year
        final date2 = DateTime(2024, 2, 29, 14, 45); // Same leap year date

        expect(date1.isSameDate(date2), isTrue);
      });

      test('handles beginning and end of year', () {
        final date1 = DateTime(2024, 1, 1, 0, 0, 0);
        final date2 = DateTime(2024, 1, 1, 23, 59, 59);

        expect(date1.isSameDate(date2), isTrue);
      });

      test('handles different years at year boundary', () {
        final date1 = DateTime(2023, 12, 31, 23, 59, 59);
        final date2 = DateTime(2024, 1, 1, 0, 0, 0);

        expect(date1.isSameDate(date2), isFalse);
      });
    });
  });
}
