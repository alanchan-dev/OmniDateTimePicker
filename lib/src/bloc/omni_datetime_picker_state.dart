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

  bool get isValidTime {
    // If on firstDate, check individual time components
    if (isFirstDate) {
      // Check hour level
      if (dateTime.hour < firstDate.hour) {
        return false;
      }
      // If same hour, check minute level
      if (dateTime.hour == firstDate.hour && dateTime.minute < firstDate.minute) {
        return false;
      }
      // If same hour and minute, check second level
      if (dateTime.hour == firstDate.hour && 
          dateTime.minute == firstDate.minute && 
          dateTime.second < firstDate.second) {
        return false;
      }
    }
    
    // If on lastDate, check individual time components
    if (isLastDate) {
      // Check hour level
      if (dateTime.hour > lastDate.hour) {
        return false;
      }
      // If same hour, check minute level
      if (dateTime.hour == lastDate.hour && dateTime.minute > lastDate.minute) {
        return false;
      }
      // If same hour and minute, check second level
      if (dateTime.hour == lastDate.hour && 
          dateTime.minute == lastDate.minute && 
          dateTime.second > lastDate.second) {
        return false;
      }
    }
    
    return true;
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
