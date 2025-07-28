import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/omni_datetime_picker_bloc.dart';
import 'bloc/time_picker_spinner_bloc.dart';

class TimePickerSpinner extends StatelessWidget {
  final String amText;
  final String pmText;
  final bool isShowSeconds;
  final bool is24HourMode;
  final int minutesInterval;
  final int secondsInterval;
  final bool isForce2Digits;

  final double height;
  final double diameterRatio;
  final double itemExtent;
  final double squeeze;
  final double magnification;
  final bool looping;
  final Widget selectionOverlay;

  const TimePickerSpinner({
    super.key,
    this.height = 200,
    this.diameterRatio = 2,
    this.itemExtent = 40,
    this.squeeze = 1,
    this.magnification = 1.1,
    this.looping = false,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
    required this.amText,
    required this.pmText,
    required this.isShowSeconds,
    required this.is24HourMode,
    required this.minutesInterval,
    required this.secondsInterval,
    required this.isForce2Digits,
  });

  @override
  Widget build(BuildContext context) {
    final datetimeBloc = context.read<OmniDatetimePickerBloc>();
    final timePickerTheme = Theme.of(context).timePickerTheme;

    return BlocProvider(
      create: (context) => TimePickerSpinnerBloc(
        amText: amText,
        pmText: pmText,
        isShowSeconds: isShowSeconds,
        is24HourMode: is24HourMode,
        minutesInterval: minutesInterval,
        secondsInterval: secondsInterval,
        isForce2Digits: isForce2Digits,
        firstDateTime: datetimeBloc.state.firstDate,
        lastDateTime: datetimeBloc.state.lastDate,
        initialDateTime: datetimeBloc.state.dateTime,
      ),
      child: BlocConsumer<TimePickerSpinnerBloc, TimePickerSpinnerState>(
        listenWhen: (previous, current) {
          if (previous is TimePickerSpinnerInitial &&
              current is TimePickerSpinnerLoaded) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          if (state is TimePickerSpinnerLoaded) {
            datetimeBloc.add(UpdateMinute(
                minute: int.parse(state.minutes[state.initialMinuteIndex])));

            if (isShowSeconds) {
              datetimeBloc.add(UpdateSecond(
                  second: int.parse(state.seconds[state.initialSecondIndex])));
            }
          }
        },
        builder: (context, state) {
          if (state is TimePickerSpinnerLoaded) {
            return SizedBox(
              height: height,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  /// Hours
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: state.initialHourIndex,
                      ),
                      diameterRatio: diameterRatio,
                      itemExtent: itemExtent,
                      squeeze: squeeze,
                      magnification: magnification,
                      looping: looping,
                      selectionOverlay: selectionOverlay,
                      onSelectedItemChanged: (index) {
                        if (!is24HourMode) {
                          final hourOffset =
                              state.abbreviationController.hasClients && 
                              state.abbreviationController.selectedItem == 1
                                  ? 12
                                  : 0;
                          final hourValue = index + hourOffset;
                          
                          datetimeBloc.add(UpdateHour(hour: hourValue));
                        } else {
                          final hourValue = int.parse(state.hours[index]);
                          datetimeBloc.add(UpdateHour(hour: hourValue));
                        }
                      },
                      children: List.generate(
                        growable: false,
                        state.hours.length,
                        (index) {
                          String hour = state.hours[index];
                          // Calculate hour value based on current state rather than controller selection
                          final int hourValue = is24HourMode ? int.parse(hour) : 
                              (hour == '12' ? 0 : int.parse(hour)) + 
                              (datetimeBloc.state.dateTime.hour >= 12 ? 12 : 0);
                          
                          final bool isDisabled = _isHourDisabled(hourValue, datetimeBloc.state);

                          if (isForce2Digits) {
                            hour = hour.padLeft(2, '0');
                          }

                          return Center(
                              child: Text(hour,
                                  style: timePickerTheme.hourMinuteTextStyle?.copyWith(
                                    color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                  ) ?? TextStyle(
                                    color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                  )));
                        },
                      ),
                    ),
                  ),

                  /// Minutes
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: state.initialMinuteIndex,
                      ),
                      diameterRatio: diameterRatio,
                      itemExtent: itemExtent,
                      squeeze: squeeze,
                      magnification: magnification,
                      looping: looping,
                      selectionOverlay: selectionOverlay,
                      onSelectedItemChanged: (index) {
                        final minuteValue = int.parse(state.minutes[index]);
                        datetimeBloc.add(UpdateMinute(minute: minuteValue));
                      },
                      children: List.generate(
                        state.minutes.length,
                        (index) {
                          String minute = state.minutes[index];
                          final int minuteValue = int.parse(minute);
                          final bool isDisabled = _isMinuteDisabled(minuteValue, datetimeBloc.state);

                          if (isForce2Digits) {
                            minute = minute.padLeft(2, '0');
                          }
                          return Center(
                              child: Text(minute,
                                  style: timePickerTheme.hourMinuteTextStyle?.copyWith(
                                    color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                  ) ?? TextStyle(
                                    color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                  )));
                        },
                      ),
                    ),
                  ),

                  /// Seconds
                  if (isShowSeconds)
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: state.initialSecondIndex,
                        ),
                        diameterRatio: diameterRatio,
                        itemExtent: itemExtent,
                        squeeze: squeeze,
                        magnification: magnification,
                        looping: looping,
                        selectionOverlay: selectionOverlay,
                        onSelectedItemChanged: (index) {
                          final secondValue = int.parse(state.seconds[index]);
                          datetimeBloc.add(UpdateSecond(second: secondValue));
                        },
                        children: List.generate(
                          state.seconds.length,
                          (index) {
                            String second = state.seconds[index];
                            final int secondValue = int.parse(second);
                            final bool isDisabled = _isSecondDisabled(secondValue, datetimeBloc.state);

                            if (isForce2Digits) {
                              second = second.padLeft(2, '0');
                            }

                            return Center(
                                child: Text(second,
                                    style: timePickerTheme.hourMinuteTextStyle?.copyWith(
                                      color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                    ) ?? TextStyle(
                                      color: isDisabled ? Colors.grey.withValues(alpha: 0.5) : null,
                                    )));
                          },
                        ),
                      ),
                    ),

                  /// AM/PM
                  if (!is24HourMode)
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: state.abbreviationController,
                        diameterRatio: diameterRatio,
                        itemExtent: itemExtent,
                        squeeze: squeeze,
                        magnification: magnification,
                        selectionOverlay: selectionOverlay,
                        onSelectedItemChanged: (index) {
                          if (index == 0) {
                            datetimeBloc
                                .add(const UpdateAbbreviation(isPm: false));
                          } else {
                            datetimeBloc
                                .add(const UpdateAbbreviation(isPm: true));
                          }
                        },
                        childCount: state.abbreviations.length,
                        itemBuilder: (context, index) {
                          return Center(
                              child: Text(state.abbreviations[index],
                                  style: timePickerTheme.hourMinuteTextStyle));
                        },
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  bool _isHourDisabled(int hour, OmniDatetimePickerState state) {
    // For hour validation, only compare at the hour level
    if (_isSameDate(state.dateTime, state.firstDate)) {
      if (hour < state.firstDate.hour) {
        return true;
      }
    }
    
    if (_isSameDate(state.dateTime, state.lastDate)) {
      if (hour > state.lastDate.hour) {
        return true;
      }
    }
    
    return false;
  }

  bool _isMinuteDisabled(int minute, OmniDatetimePickerState state) {
    // For minute validation, compare at the minute level when on the exact hour
    if (_isSameDate(state.dateTime, state.firstDate) && 
        state.dateTime.hour == state.firstDate.hour) {
      if (minute < state.firstDate.minute) {
        return true;
      }
    }
    
    if (_isSameDate(state.dateTime, state.lastDate) && 
        state.dateTime.hour == state.lastDate.hour) {
      if (minute > state.lastDate.minute) {
        return true;
      }
    }
    
    return false;
  }

  bool _isSecondDisabled(int second, OmniDatetimePickerState state) {
    // For second validation, compare at the second level when on the exact hour and minute
    if (_isSameDate(state.dateTime, state.firstDate) && 
        state.dateTime.hour == state.firstDate.hour &&
        state.dateTime.minute == state.firstDate.minute) {
      if (second < state.firstDate.second) {
        return true;
      }
    }
    
    if (_isSameDate(state.dateTime, state.lastDate) && 
        state.dateTime.hour == state.lastDate.hour &&
        state.dateTime.minute == state.lastDate.minute) {
      if (second > state.lastDate.second) {
        return true;
      }
    }
    
    return false;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
