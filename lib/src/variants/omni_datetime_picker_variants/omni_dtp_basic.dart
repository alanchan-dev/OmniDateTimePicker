import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:omni_datetime_picker/src/components/button_row.dart';
import 'package:omni_datetime_picker/src/components/calendar.dart';
import 'package:omni_datetime_picker/src/components/time_picker_spinner.dart';

class OmniDtpBasic extends StatelessWidget {
  const OmniDtpBasic({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.isShowSeconds,
    this.is24HourMode,
    this.minutesInterval,
    this.secondsInterval,
    this.constraints,
    this.type,
    this.selectableDayPredicate,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final BoxConstraints? constraints;
  final OmniDateTimePickerType? type;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    DateTime selectedDateTime = DateTime.now();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: constraints ??
            const BoxConstraints(
              maxWidth: 350,
              maxHeight: 650,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Calendar(
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateChanged: (value) {
                DateTime tempDateTime = DateTime(
                  value.year,
                  value.month,
                  value.day,
                  selectedDateTime.hour,
                  selectedDateTime.minute,
                  isShowSeconds ?? false ? selectedDateTime.second : 0,
                );

                selectedDateTime = tempDateTime;
              },
              selectableDayPredicate: selectableDayPredicate,
            ),
            if (type == OmniDateTimePickerType.dateAndTime)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TimePickerSpinner(
                  amText: localizations.anteMeridiemAbbreviation,
                  pmText: localizations.postMeridiemAbbreviation,
                  isShowSeconds: isShowSeconds ?? false,
                  is24HourMode: is24HourMode ?? false,
                  minutesInterval: minutesInterval ?? 1,
                  secondsInterval: secondsInterval ?? 1,
                  isForce2Digits: false,
                  onTimeChange: (value) {
                    DateTime tempDateTime = DateTime(
                      selectedDateTime.year,
                      selectedDateTime.month,
                      selectedDateTime.day,
                      value.hour,
                      value.minute,
                      isShowSeconds ?? false ? value.second : 0,
                    );

                    selectedDateTime = tempDateTime;
                  },
                ),
              ),
            ButtonRow(onSavePressed: () {
              Navigator.pop<DateTime>(
                context,
                selectedDateTime,
              );
            }),
          ],
        ),
      ),
    );
  }
}
