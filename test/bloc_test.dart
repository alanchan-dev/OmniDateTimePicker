import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_datetime_picker/src/bloc/omni_datetime_picker_bloc.dart';

void main() {
  group('OmniDatetimePickerBloc Tests', () {
    late OmniDatetimePickerBloc bloc;
    final initialDateTime = DateTime(2024, 6, 15, 10, 30, 45);
    final firstDate = DateTime(2024, 1, 1);
    final lastDate = DateTime(2024, 12, 31);

    setUp(() {
      bloc = OmniDatetimePickerBloc(
        initialDateTime: initialDateTime,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is DateTimeInitial with correct values', () {
      expect(bloc.state, isA<DateTimeInitial>());
      expect(bloc.state.dateTime, equals(initialDateTime));
      expect(bloc.state.firstDate, equals(firstDate));
      expect(bloc.state.lastDate, equals(lastDate));
    });

    group('UpdateDate Event', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'emits DateTimeChanged when UpdateDate is added',
        build: () => bloc,
        act: (bloc) => bloc.add(UpdateDate(dateTime: DateTime(2024, 7, 20))),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime,
            'dateTime',
            DateTime(2024, 7, 20, 10, 30, 45),
          ),
        ],
      );

      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'preserves time when updating date',
        build: () => bloc,
        act: (bloc) => bloc.add(UpdateDate(dateTime: DateTime(2024, 12, 25))),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime,
            'dateTime',
            DateTime(2024, 12, 25, 10, 30, 45),
          ),
        ],
      );
    });

    group('UpdateHour Event', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'emits DateTimeChanged when UpdateHour is added',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateHour(hour: 14)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.hour,
            'hour',
            14,
          ),
        ],
      );

      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'preserves existing hour when null is passed',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateHour(hour: null)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.hour,
            'hour',
            10,
          ),
        ],
      );
    });

    group('UpdateMinute Event', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'emits DateTimeChanged when UpdateMinute is added',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateMinute(minute: 45)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.minute,
            'minute',
            45,
          ),
        ],
      );

      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'preserves existing minute when null is passed',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateMinute(minute: null)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.minute,
            'minute',
            30,
          ),
        ],
      );
    });

    group('UpdateSecond Event', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'emits DateTimeChanged when UpdateSecond is added',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateSecond(second: 15)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.second,
            'second',
            15,
          ),
        ],
      );

      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'preserves existing second when null is passed',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateSecond(second: null)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.second,
            'second',
            45,
          ),
        ],
      );
    });

    group('UpdateAbbreviation Event', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'adds 12 hours when switching to PM',
        build: () => bloc,
        act: (bloc) => bloc.add(const UpdateAbbreviation(isPm: true)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.hour,
            'hour',
            22, // 10 + 12
          ),
        ],
      );

      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'subtracts 12 hours when switching to AM',
        build: () => OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 6, 15, 14, 30, 45), // 2:30 PM
          firstDate: firstDate,
          lastDate: lastDate,
        ),
        act: (bloc) => bloc.add(const UpdateAbbreviation(isPm: false)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.hour,
            'hour',
            2, // 14 - 12
          ),
        ],
      );
    });

    group('State Properties', () {
      test('isFirstDate returns true when date matches firstDate', () {
        final testBloc = OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 1, 1, 10, 30),
          firstDate: DateTime(2024, 1, 1, 0, 0),
          lastDate: DateTime(2024, 12, 31),
        );

        expect(testBloc.state.isFirstDate, isTrue);
        testBloc.close();
      });

      test('isLastDate returns true when date matches lastDate', () {
        final testBloc = OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 12, 31, 10, 30),
          firstDate: DateTime(2024, 1, 1),
          lastDate: DateTime(2024, 12, 31, 23, 59),
        );

        expect(testBloc.state.isLastDate, isTrue);
        testBloc.close();
      });

      test('isValidTime returns true for valid time within bounds', () {
        final testBloc = OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 6, 15, 10, 30),
          firstDate: DateTime(2024, 1, 1, 8, 0),
          lastDate: DateTime(2024, 12, 31, 18, 0),
        );

        expect(testBloc.state.isValidTime, isTrue);
        testBloc.close();
      });

      test(
          'isValidTime returns false when time is before firstDate time on same day',
          () {
        final testBloc = OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 1, 1, 7, 30), // Before 8:00 AM
          firstDate: DateTime(2024, 1, 1, 8, 0),
          lastDate: DateTime(2024, 12, 31, 18, 0),
        );

        expect(testBloc.state.isValidTime, isFalse);
        testBloc.close();
      });

      test(
          'isValidTime returns false when time is after lastDate time on same day',
          () {
        final testBloc = OmniDatetimePickerBloc(
          initialDateTime: DateTime(2024, 12, 31, 19, 30), // After 6:00 PM
          firstDate: DateTime(2024, 1, 1, 8, 0),
          lastDate: DateTime(2024, 12, 31, 18, 0),
        );

        expect(testBloc.state.isValidTime, isFalse);
        testBloc.close();
      });
    });

    group('Debouncing', () {
      blocTest<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        'debounces multiple rapid events',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const UpdateHour(hour: 11));
          bloc.add(const UpdateHour(hour: 12));
          bloc.add(const UpdateHour(hour: 13));
        },
        wait: const Duration(milliseconds: 300),
        expect: () => [
          isA<DateTimeChanged>().having(
            (state) => state.dateTime.hour,
            'hour',
            13, // Only the last event should be processed
          ),
        ],
      );
    });
  });
}
