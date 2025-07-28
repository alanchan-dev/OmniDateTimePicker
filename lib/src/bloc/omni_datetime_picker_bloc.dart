import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'omni_datetime_picker_event.dart';
part 'omni_datetime_picker_state.dart';

class OmniDatetimePickerBloc
    extends Bloc<OmniDatetimePickerEvent, OmniDatetimePickerState> {
  OmniDatetimePickerBloc({
    required DateTime initialDateTime,
    required DateTime firstDate,
    required DateTime lastDate,
  }) : super(DateTimeInitial(
          dateTime: initialDateTime,
          firstDate: firstDate,
          lastDate: lastDate,
        )) {
    on<UpdateDate>(
      (event, emit) => _updateDate(event, emit),
      transformer: debounce(
        const Duration(milliseconds: 50),
      ),
    );
    on<UpdateHour>(
      (event, emit) => _updateHour(event, emit),
      transformer: debounce(
        const Duration(milliseconds: 150),
      ),
    );
    on<UpdateMinute>(
      (event, emit) => _updateMinute(event, emit),
      transformer: debounce(
        const Duration(milliseconds: 150),
      ),
    );
    on<UpdateSecond>(
      (event, emit) => _updateSecond(event, emit),
      transformer: debounce(
        const Duration(milliseconds: 150),
      ),
    );

    on<UpdateAbbreviation>(
      (event, emit) => _updateAbbreviation(event, emit),
      transformer: debounce(
        const Duration(milliseconds: 150),
      ),
    );
  }

  void _updateDate(UpdateDate event, Emitter<OmniDatetimePickerState> emit) {
    emit(
      DateTimeChanged(
        dateTime: state.dateTime.copyWith(
          year: event.dateTime.year,
          month: event.dateTime.month,
          day: event.dateTime.day,
        ),
        firstDate: state.firstDate,
        lastDate: state.lastDate,
      ),
    );
  }

  void _updateHour(UpdateHour event, Emitter<OmniDatetimePickerState> emit) {
    emit(
      DateTimeChanged(
        dateTime: state.dateTime.copyWith(
          hour: event.hour ?? state.dateTime.hour,
        ),
        firstDate: state.firstDate,
        lastDate: state.lastDate,
      ),
    );
  }

  void _updateMinute(
      UpdateMinute event, Emitter<OmniDatetimePickerState> emit) {
    emit(
      DateTimeChanged(
        dateTime: state.dateTime.copyWith(
          minute: event.minute ?? state.dateTime.minute,
        ),
        firstDate: state.firstDate,
        lastDate: state.lastDate,
      ),
    );
  }

  void _updateSecond(
      UpdateSecond event, Emitter<OmniDatetimePickerState> emit) {
    emit(
      DateTimeChanged(
        dateTime: state.dateTime.copyWith(
          second: event.second ?? state.dateTime.second,
        ),
        firstDate: state.firstDate,
        lastDate: state.lastDate,
      ),
    );
  }

  void _updateAbbreviation(
      UpdateAbbreviation event, Emitter<OmniDatetimePickerState> emit) {
    final updatedHour =
        event.isPm ? state.dateTime.hour + 12 : state.dateTime.hour - 12;

    final dateTime = DateTime(
      state.dateTime.year,
      state.dateTime.month,
      state.dateTime.day,
      updatedHour,
      state.dateTime.minute,
      state.dateTime.second,
    );

    emit(
      DateTimeChanged(
        dateTime: dateTime,
        firstDate: state.firstDate,
        lastDate: state.lastDate,
      ),
    );
  }

  EventTransformer<Event> debounce<Event>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).asyncExpand(mapper);
  }
}
