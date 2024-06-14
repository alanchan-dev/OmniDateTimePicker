part of 'omni_datetime_picker_bloc.dart';

sealed class OmniDatetimePickerEvent extends Equatable {
  const OmniDatetimePickerEvent();

  @override
  List<Object> get props => [];
}

final class UpdateDate extends OmniDatetimePickerEvent {
  final DateTime dateTime;

  const UpdateDate({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

final class UpdateHour extends OmniDatetimePickerEvent {
  final int? hour;

  const UpdateHour({required this.hour});
}

final class UpdateMinute extends OmniDatetimePickerEvent {
  final int? minute;

  const UpdateMinute({required this.minute});
}

final class UpdateSecond extends OmniDatetimePickerEvent {
  final int? second;

  const UpdateSecond({required this.second});
}

final class UpdateAbbreviation extends OmniDatetimePickerEvent {
  final bool isPm;

  const UpdateAbbreviation({required this.isPm});
}
