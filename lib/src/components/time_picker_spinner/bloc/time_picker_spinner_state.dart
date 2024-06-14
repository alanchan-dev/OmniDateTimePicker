part of 'time_picker_spinner_bloc.dart';

sealed class TimePickerSpinnerState extends Equatable {
  const TimePickerSpinnerState();

  @override
  List<Object> get props => [];
}

final class TimePickerSpinnerInitial extends TimePickerSpinnerState {}

final class TimePickerSpinnerLoaded extends TimePickerSpinnerState {
  final List<String> allHours;
  final List<String> allMinutes;
  final List<String> allSeconds;

  final List<String> hours;
  final List<String> minutes;
  final List<String> seconds;
  final List<String> abbreviations;
  final int initialHourIndex;
  final int initialMinuteIndex;
  final int initialSecondIndex;
  final int initialAbbreviationIndex;
  final FixedExtentScrollController abbreviationController;

  const TimePickerSpinnerLoaded({
    required this.allHours,
    required this.allMinutes,
    required this.allSeconds,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.abbreviations,
    required this.initialHourIndex,
    required this.initialMinuteIndex,
    required this.initialSecondIndex,
    required this.initialAbbreviationIndex,
    required this.abbreviationController,
  });

  @override
  List<Object> get props => [
        allHours,
        allMinutes,
        allSeconds,
        hours,
        minutes,
        seconds,
        abbreviations,
        initialHourIndex,
        initialMinuteIndex,
        initialSecondIndex,
        initialAbbreviationIndex,
        abbreviationController,
      ];

  TimePickerSpinnerLoaded copyWith({
    List<String>? allHours,
    List<String>? allMinutes,
    List<String>? allSeconds,
    List<String>? hours,
    List<String>? minutes,
    List<String>? seconds,
    List<String>? abbreviations,
    int? initialHourIndex,
    int? initialMinuteIndex,
    int? initialSecondIndex,
    int? initialAbbreviationIndex,
    FixedExtentScrollController? abbreviationController,
    List<String>? firstHours,
    List<String>? firstMinutes,
    List<String>? firstSeconds,
    List<String>? lastHours,
    List<String>? lastMinutes,
    List<String>? lastSeconds,
  }) {
    return TimePickerSpinnerLoaded(
      allHours: allHours ?? this.allHours,
      allMinutes: allMinutes ?? this.allMinutes,
      allSeconds: allSeconds ?? this.allSeconds,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      abbreviations: abbreviations ?? this.abbreviations,
      initialHourIndex: initialHourIndex ?? this.initialHourIndex,
      initialMinuteIndex: initialMinuteIndex ?? this.initialMinuteIndex,
      initialSecondIndex: initialSecondIndex ?? this.initialSecondIndex,
      initialAbbreviationIndex:
          initialAbbreviationIndex ?? this.initialAbbreviationIndex,
      abbreviationController:
          abbreviationController ?? this.abbreviationController,
    );
  }
}
