import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/src/time_picker_spinner.dart';

import '../omni_datetime_picker.dart';

/// Omni DateTime Picker
///
/// If properties are not given, default value will be used.
class OmniDateTimePicker extends StatefulWidget {
  /// Start initial datetime
  ///
  /// Default value: DateTime.now()
  final DateTime? startInitialDate;

  /// Minimum date that can be selected
  ///
  /// Default value: DateTime.now().subtract(const Duration(days: 3652))
  final DateTime? startFirstDate;

  /// Maximum date that can be selected
  ///
  /// Default value: DateTime.now().add(const Duration(days: 3652))
  final DateTime? startLastDate;

  final OmniDateTimePickerType type;
  final bool? is24HourMode;
  final bool? isShowSeconds;

  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? calendarTextColor;
  final Color? tabTextColor;
  final Color? unselectedTabBackgroundColor;
  final Color? buttonTextColor;
  final TextStyle? timeSpinnerTextStyle;
  final TextStyle? timeSpinnerHighlightedTextStyle;
  final Radius? borderRadius;
  final int? minutesInterval;

  const OmniDateTimePicker({
    Key? key,
    this.startInitialDate,
    this.startFirstDate,
    this.startLastDate,
    required this.type,
    this.is24HourMode,
    this.isShowSeconds,
    this.primaryColor,
    this.backgroundColor,
    this.calendarTextColor,
    this.tabTextColor,
    this.unselectedTabBackgroundColor,
    this.buttonTextColor,
    this.timeSpinnerTextStyle,
    this.timeSpinnerHighlightedTextStyle,
    this.borderRadius,
    this.minutesInterval,
  }) : super(key: key);

  @override
  State<OmniDateTimePicker> createState() => _OmniDateTimePickerState();
}

class _OmniDateTimePickerState extends State<OmniDateTimePicker>
    with SingleTickerProviderStateMixin {
  /// startDateTime will be returned after clicking Done
  ///
  /// Initial value: Current DateTime
  DateTime startDateTime = DateTime.now();

  late MaterialLocalizations _localizations;

  @override
  void initState() {
    if (widget.startInitialDate != null) {
      startDateTime = widget.startInitialDate!;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: widget.primaryColor ?? Colors.blue,
                surface: widget.backgroundColor ?? Colors.white,
                onSurface: widget.calendarTextColor ?? Colors.black,
              ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 120),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: widget.borderRadius ?? const Radius.circular(16),
                      topRight:
                          widget.borderRadius ?? const Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalendarDatePicker(
                      initialDate: widget.startInitialDate ?? DateTime.now(),
                      firstDate: widget.startFirstDate ??
                          DateTime.now().subtract(const Duration(days: 3652)),
                      lastDate: widget.startLastDate ??
                          DateTime.now().add(const Duration(days: 3652)),
                      onDateChanged: (dateTime) {
                        startDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          widget.type == OmniDateTimePickerType.date ? 0 : startDateTime.hour,
                          widget.type == OmniDateTimePickerType.date ? 0 : startDateTime.minute,
                        );
                      },
                    ),
                    widget.type == OmniDateTimePickerType.dateAndTime ? Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TimePickerSpinner(
                        amText: _localizations.anteMeridiemAbbreviation,
                        pmText: _localizations.postMeridiemAbbreviation,
                        minutesInterval: widget.minutesInterval ?? 1,
                        is24HourMode: widget.is24HourMode ?? false,
                        isShowSeconds: widget.isShowSeconds ?? false,
                        normalTextStyle: widget.timeSpinnerTextStyle ??
                            TextStyle(
                                fontSize: 18,
                                color:
                                    widget.calendarTextColor ?? Colors.black54),
                        highlightedTextStyle: widget
                                .timeSpinnerHighlightedTextStyle ??
                            TextStyle(
                                fontSize: 24,
                                color:
                                    widget.calendarTextColor ?? Colors.black),
                        time: startDateTime,
                        onTimeChange: (dateTime) {
                          DateTime tempStartDateTime = DateTime(
                            startDateTime.year,
                            startDateTime.month,
                            startDateTime.day,
                            dateTime.hour,
                            dateTime.minute,
                            dateTime.second,
                          );

                          startDateTime = tempStartDateTime;
                        },
                      ),
                    ) : Container(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        widget.borderRadius ?? const Radius.circular(16),
                    bottomRight:
                        widget.borderRadius ?? const Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(widget.backgroundColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop<DateTime>();
                        },
                        child: Text(
                          // "Cancel",
                          _localizations.cancelButtonLabel,
                          style: TextStyle(
                              color: widget.buttonTextColor ?? Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                      child: VerticalDivider(
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(widget.backgroundColor),
                        ),
                        onPressed: () {
                          Navigator.pop<DateTime>(
                            context,
                            startDateTime,
                          );
                        },
                        child: Text(
                          // "Save",
                          _localizations.saveButtonLabel,
                          style: TextStyle(
                              color: widget.buttonTextColor ?? Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
