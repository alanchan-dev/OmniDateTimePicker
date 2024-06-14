part of 'omni_datetime_picker_bloc.dart';

sealed class OmniDatetimePickerState extends Equatable {
  final DateTime dateTime;
  final DateTime firstDate;
  final DateTime lastDate;

  const OmniDatetimePickerState({
    required this.dateTime,
    required this.firstDate,
    required this.lastDate,
  });

  bool get isFirstDate {
    if (dateTime.year == firstDate.year &&
        dateTime.month == firstDate.month &&
        dateTime.day == firstDate.day) {
      return true;
    }

    return false;
  }

  bool get isLastDate {
    if (dateTime.year == lastDate.year &&
        dateTime.month == lastDate.month &&
        dateTime.day == lastDate.day) {
      return true;
    }

    return false;
  }

  @override
  List<Object> get props => [
        dateTime,
        firstDate,
        lastDate,
      ];
}

final class DateTimeInitial extends OmniDatetimePickerState {
  const DateTimeInitial({
    required super.dateTime,
    required super.firstDate,
    required super.lastDate,
  });
}

final class DateTimeChanged extends OmniDatetimePickerState {
  const DateTimeChanged({
    required super.dateTime,
    required super.firstDate,
    required super.lastDate,
  });

  @override
  List<Object> get props => [
        dateTime,
        firstDate,
        lastDate,
      ];
}
