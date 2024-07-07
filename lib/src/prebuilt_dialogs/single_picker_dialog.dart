import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/button_row.dart';
import '../enums/omni_datetime_picker_type.dart';
import '../omni_datetime_picker.dart';

class SinglePickerDialog extends StatelessWidget {
  final Widget? title;
  final Widget? titleSeparator;
  final Widget? separator;

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;

  final String? amText;
  final String? pmText;
  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final bool? isForce2Digits;
  final bool? looping;
  final Widget? selectionOverlay;

  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final OmniDateTimePickerType? type;

  const SinglePickerDialog({
    super.key,
    this.title,
    this.titleSeparator,
    this.separator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.amText,
    this.pmText,
    this.isShowSeconds,
    this.is24HourMode,
    this.minutesInterval,
    this.secondsInterval,
    this.isForce2Digits,
    this.looping,
    this.selectionOverlay,
    this.padding,
    this.insetPadding,
    this.borderRadius,
    this.constraints,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDateTime = initialDate ?? DateTime.now();

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(16))),
      child: ConstrainedBox(
        constraints: constraints ?? const BoxConstraints.tightFor(),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) title!,
              if (title != null && titleSeparator != null) titleSeparator!,
              Flexible(
                child: SingleChildScrollView(
                  child: OmniDateTimePicker(
                    onDateTimeChanged: (dateTime) {
                      selectedDateTime = dateTime;
                    },
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    selectableDayPredicate: selectableDayPredicate,
                    amText: amText,
                    pmText: pmText,
                    isShowSeconds: isShowSeconds ?? false,
                    is24HourMode: is24HourMode ?? false,
                    minutesInterval: minutesInterval ?? 1,
                    secondsInterval: secondsInterval ?? 1,
                    isForce2Digits: isForce2Digits ?? true,
                    looping: looping ?? true,
                    selectionOverlay: selectionOverlay ??
                        const CupertinoPickerDefaultSelectionOverlay(),
                    separator: separator,
                    type: type ?? OmniDateTimePickerType.dateAndTime,
                  ),
                ),
              ),
              ButtonRow(
                onCancelPressed: () {
                  Navigator.of(context).pop<DateTime>();
                },
                onSavePressed: () {
                  Navigator.pop<DateTime>(
                    context,
                    selectedDateTime,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
