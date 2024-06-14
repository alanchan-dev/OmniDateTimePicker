import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/omni_datetime_picker_bloc.dart';
import 'components/calendar/calendar.dart';
import 'components/custom_scroll_behavior.dart';
import 'components/time_picker_spinner/time_picker_spinner.dart';
import 'enums/omni_datetime_picker_type.dart';

class OmniDateTimePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final ValueChanged<DateTime> onDateTimeChanged;

  final String? amText;
  final String? pmText;
  final bool isShowSeconds;
  final bool is24HourMode;
  final int minutesInterval;
  final int secondsInterval;
  final bool isForce2Digits;
  final bool looping;

  final Widget selectionOverlay;

  final Widget? separator;
  final OmniDateTimePickerType type;

  const OmniDateTimePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    required this.onDateTimeChanged,
    this.amText,
    this.pmText,
    this.isShowSeconds = false,
    this.is24HourMode = false,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.isForce2Digits = true,
    this.looping = true,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
    this.separator,
    this.type = OmniDateTimePickerType.dateAndTime,
  });

  @override
  State<OmniDateTimePicker> createState() => _OmniDateTimePickerState();
}

class _OmniDateTimePickerState extends State<OmniDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final defaultInitialDate = DateTime.now();
    final defaultFirstDate = DateTime.fromMillisecondsSinceEpoch(0);
    final defaultLastDate = DateTime(2100);

    return BlocProvider(
      create: (context) => OmniDatetimePickerBloc(
        initialDateTime: widget.initialDate ?? defaultInitialDate,
        firstDate: widget.firstDate ?? defaultFirstDate,
        lastDate: widget.lastDate ?? defaultLastDate,
      ),
      child: BlocConsumer<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        listener: (context, state) {
          widget.onDateTimeChanged(state.dateTime);
        },
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.type == OmniDateTimePickerType.dateAndTime ||
                    widget.type == OmniDateTimePickerType.date)
                  Calendar(
                    initialDate: state.dateTime,
                    firstDate: state.firstDate,
                    lastDate: state.lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    onDateChanged: (datetime) {
                      context
                          .read<OmniDatetimePickerBloc>()
                          .add(UpdateDate(dateTime: datetime));
                    },
                  ),
                if (widget.separator != null) widget.separator!,
                if (widget.type == OmniDateTimePickerType.dateAndTime ||
                    widget.type == OmniDateTimePickerType.time)
                  TimePickerSpinner(
                    amText:
                        widget.amText ?? localizations.anteMeridiemAbbreviation,
                    pmText:
                        widget.pmText ?? localizations.postMeridiemAbbreviation,
                    isShowSeconds: widget.isShowSeconds,
                    is24HourMode: widget.is24HourMode,
                    minutesInterval: widget.minutesInterval,
                    secondsInterval: widget.secondsInterval,
                    isForce2Digits: widget.isForce2Digits,
                    looping: widget.looping,
                    selectionOverlay: widget.selectionOverlay,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
