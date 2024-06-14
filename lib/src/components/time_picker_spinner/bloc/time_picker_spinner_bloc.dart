import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'time_picker_spinner_event.dart';
part 'time_picker_spinner_state.dart';

class TimePickerSpinnerBloc
    extends Bloc<TimePickerSpinnerEvent, TimePickerSpinnerState> {
  final String amText;
  final String pmText;
  final bool isShowSeconds;
  final bool is24HourMode;
  final int minutesInterval;
  final int secondsInterval;
  final bool isForce2Digits;
  final DateTime firstDateTime;
  final DateTime lastDateTime;

  TimePickerSpinnerBloc({
    required this.amText,
    required this.pmText,
    required this.isShowSeconds,
    required this.is24HourMode,
    required this.minutesInterval,
    required this.secondsInterval,
    required this.isForce2Digits,
    required this.firstDateTime,
    required this.lastDateTime,
  }) : super(TimePickerSpinnerInitial()) {
    on<Initialize>(_initialize);

    if (state is TimePickerSpinnerInitial) {
      add(Initialize());
    }
  }

  Future<void> _initialize(TimePickerSpinnerEvent event,
      Emitter<TimePickerSpinnerState> emit) async {
    final hours = _generateHours();
    final minutes = _generateMinutes();
    final seconds = _generateSeconds();
    final abbreviations = _generateAbbreviations();

    final now = DateTime.now();
    final initialHourIndex = _getInitialHourIndex(hours: hours, now: now);
    final initialMinuteIndex =
        _getInitialMinuteIndex(minutes: minutes, now: now);
    final initialSecondIndex =
        _getInitialSecondIndex(seconds: seconds, now: now);
    final initialAbbreviationIndex =
        _getInitialAbbreviationIndex(abbreviations: abbreviations, now: now);

    final abbreviationController = FixedExtentScrollController(
      initialItem: initialAbbreviationIndex,
    );

    emit(TimePickerSpinnerLoaded(
      allHours: hours,
      allMinutes: minutes,
      allSeconds: seconds,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      abbreviations: abbreviations,
      initialHourIndex: initialHourIndex,
      initialMinuteIndex: initialMinuteIndex,
      initialSecondIndex: initialSecondIndex,
      initialAbbreviationIndex: initialAbbreviationIndex,
      abbreviationController: abbreviationController,
    ));
  }

  int _getInitialHourIndex({
    required List<String> hours,
    required DateTime now,
  }) {
    if (now.hour >= 12 && !is24HourMode) {
      return hours.indexWhere((e) => e == (now.hour - 12).toString());
    }

    return hours.indexWhere((e) => e == now.hour.toString());
  }

  int _getInitialMinuteIndex({
    required List<String> minutes,
    required DateTime now,
  }) {
    return minutes.indexWhere((e) => e == now.minute.toString());
  }

  int _getInitialSecondIndex({
    required List<String> seconds,
    required DateTime now,
  }) {
    return seconds.indexWhere((e) => e == now.second.toString());
  }

  int _getInitialAbbreviationIndex({
    required List<String> abbreviations,
    required DateTime now,
  }) {
    if (now.hour >= 12) {
      return 1;
    } else {
      return 0;
    }
  }

  List<String> _generateHours() {
    final List<String> hours = List.generate(
      is24HourMode ? 24 : 12,
      (index) {
        return '$index';
      },
    );

    return hours;
  }

  List<String> _generateMinutes() {
    final List<String> minutes = List.generate(
      (60 / minutesInterval).floor(),
      (index) {
        return '${index * minutesInterval}';
      },
    );
    return minutes;
  }

  List<String> _generateSeconds() {
    final List<String> seconds = List.generate(
      (60 / secondsInterval).floor(),
      (index) {
        return '${index * secondsInterval}';
      },
    );
    return seconds;
  }

  List<String> _generateAbbreviations() {
    return [
      amText,
      pmText,
    ];
  }
}
