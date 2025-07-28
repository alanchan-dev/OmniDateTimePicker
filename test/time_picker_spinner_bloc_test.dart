import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_datetime_picker/src/components/time_picker_spinner/bloc/time_picker_spinner_bloc.dart';

void main() {
  group('TimePickerSpinnerBloc Tests', () {
    late TimePickerSpinnerBloc bloc;
    final initialDateTime = DateTime(2024, 6, 15, 14, 30, 45); // 2:30:45 PM
    final firstDateTime = DateTime(2024, 1, 1);
    final lastDateTime = DateTime(2024, 12, 31);

    setUp(() {
      bloc = TimePickerSpinnerBloc(
        amText: 'AM',
        pmText: 'PM',
        isShowSeconds: true,
        is24HourMode: false,
        minutesInterval: 1,
        secondsInterval: 1,
        isForce2Digits: true,
        firstDateTime: firstDateTime,
        lastDateTime: lastDateTime,
        initialDateTime: initialDateTime,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is TimePickerSpinnerInitial', () {
      final testBloc = TimePickerSpinnerBloc(
        amText: 'AM',
        pmText: 'PM',
        isShowSeconds: false,
        is24HourMode: false,
        minutesInterval: 1,
        secondsInterval: 1,
        isForce2Digits: true,
        firstDateTime: firstDateTime,
        lastDateTime: lastDateTime,
        initialDateTime: initialDateTime,
      );

      expect(testBloc.state, isA<TimePickerSpinnerInitial>());
      testBloc.close();
    });

    blocTest<TimePickerSpinnerBloc, TimePickerSpinnerState>(
      'emits TimePickerSpinnerLoaded when Initialize is added',
      build: () => bloc,
      act: (bloc) => bloc.add(Initialize()),
      expect: () => [
        isA<TimePickerSpinnerLoaded>(),
      ],
    );

    group('12-Hour Mode Tests', () {
      late TimePickerSpinnerBloc bloc12Hour;

      setUp(() {
        bloc12Hour = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: true,
          is24HourMode: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: DateTime(2024, 6, 15, 14, 30, 45), // 2:30 PM
        );
      });

      tearDown(() {
        bloc12Hour.close();
      });

      test('generates correct hours for 12-hour mode', () async {
        bloc12Hour.add(Initialize());
        final state = await bloc12Hour.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.hours.length, equals(12));
        expect(loaded.hours.first, equals('12')); // 12 AM should be first
        expect(loaded.hours.contains('1'), isTrue);
        expect(loaded.hours.contains('11'), isTrue);
      });

      test('sets correct initial hour index for PM time', () async {
        bloc12Hour.add(Initialize());
        final state = await bloc12Hour.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // 2:30 PM should have hour index for '2'
        expect(loaded.initialHourIndex, equals(2));
      });

      test('sets correct initial abbreviation index for PM time', () async {
        bloc12Hour.add(Initialize());
        final state = await bloc12Hour.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // PM should be index 1 (AM=0, PM=1)
        expect(loaded.initialAbbreviationIndex, equals(1));
      });
    });

    group('24-Hour Mode Tests', () {
      late TimePickerSpinnerBloc bloc24Hour;

      setUp(() {
        bloc24Hour = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: true,
          is24HourMode: true,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: DateTime(2024, 6, 15, 14, 30, 45), // 14:30
        );
      });

      tearDown(() {
        bloc24Hour.close();
      });

      test('generates correct hours for 24-hour mode', () async {
        bloc24Hour.add(Initialize());
        final state = await bloc24Hour.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.hours.length, equals(24));
        expect(loaded.hours.first, equals('0')); // Should start with 0
        expect(loaded.hours.last, equals('23')); // Should end with 23
      });

      test('sets correct initial hour index for 24-hour time', () async {
        bloc24Hour.add(Initialize());
        final state = await bloc24Hour.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // 14:30 should have hour index for '14'
        expect(loaded.initialHourIndex, equals(14));
      });
    });

    group('Minutes and Seconds Generation', () {
      test('generates correct minutes with default interval', () async {
        bloc.add(Initialize());
        final state = await bloc.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.minutes.length, equals(60)); // 0-59 minutes
        expect(loaded.minutes.first, equals('0'));
        expect(loaded.minutes.last, equals('59'));
      });

      test('generates correct minutes with custom interval', () async {
        final blocCustomInterval = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: true,
          is24HourMode: false,
          minutesInterval: 5, // 5-minute intervals
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: initialDateTime,
        );

        blocCustomInterval.add(Initialize());
        final state = await blocCustomInterval.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.minutes.length, equals(12)); // 60/5 = 12 intervals
        expect(loaded.minutes.first, equals('0'));
        expect(loaded.minutes[1], equals('5'));
        expect(loaded.minutes.last, equals('55'));

        blocCustomInterval.close();
      });

      test('generates correct seconds with default interval', () async {
        bloc.add(Initialize());
        final state = await bloc.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.seconds.length, equals(60)); // 0-59 seconds
        expect(loaded.seconds.first, equals('0'));
        expect(loaded.seconds.last, equals('59'));
      });
    });

    group('Initial Index Calculations', () {
      test('calculates correct initial minute index', () async {
        bloc.add(Initialize());
        final state = await bloc.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // 30 minutes should be at index 30
        expect(loaded.initialMinuteIndex, equals(30));
      });

      test('calculates correct initial second index', () async {
        bloc.add(Initialize());
        final state = await bloc.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // 45 seconds should be at index 45
        expect(loaded.initialSecondIndex, equals(45));
      });
    });

    group('Abbreviations Tests', () {
      test('generates correct abbreviations', () async {
        bloc.add(Initialize());
        final state = await bloc.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        expect(loaded.abbreviations.length, equals(2));
        expect(loaded.abbreviations[0], equals('AM'));
        expect(loaded.abbreviations[1], equals('PM'));
      });

      test('sets correct abbreviation index for AM time', () async {
        final blocAM = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: true,
          is24HourMode: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: DateTime(2024, 6, 15, 10, 30, 45), // 10:30 AM
        );

        blocAM.add(Initialize());
        final state = await blocAM.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // AM should be index 0
        expect(loaded.initialAbbreviationIndex, equals(0));

        blocAM.close();
      });
    });

    group('Edge Cases', () {
      test('handles midnight correctly (12:00 AM)', () async {
        final blocMidnight = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: false,
          is24HourMode: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: DateTime(2024, 6, 15, 0, 0, 0), // Midnight
        );

        blocMidnight.add(Initialize());
        final state = await blocMidnight.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // Midnight should show as 12 AM (index 0 for '12')
        expect(loaded.initialHourIndex, equals(0));
        expect(loaded.initialAbbreviationIndex, equals(0)); // AM

        blocMidnight.close();
      });

      test('handles noon correctly (12:00 PM)', () async {
        final blocNoon = TimePickerSpinnerBloc(
          amText: 'AM',
          pmText: 'PM',
          isShowSeconds: false,
          is24HourMode: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          firstDateTime: firstDateTime,
          lastDateTime: lastDateTime,
          initialDateTime: DateTime(2024, 6, 15, 12, 0, 0), // Noon
        );

        blocNoon.add(Initialize());
        final state = await blocNoon.stream.firstWhere(
          (state) => state is TimePickerSpinnerLoaded,
        );

        final loaded = state as TimePickerSpinnerLoaded;
        // Noon should show as 12 PM (index 0 for '12')
        expect(loaded.initialHourIndex, equals(0));
        expect(loaded.initialAbbreviationIndex, equals(1)); // PM

        blocNoon.close();
      });
    });
  });
}
