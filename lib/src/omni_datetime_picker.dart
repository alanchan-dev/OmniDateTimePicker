import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:omni_datetime_picker/src/variants/omni_datetime_picker_variants/omni_dtp_basic.dart';

class OmniDateTimePicker extends StatelessWidget {
  const OmniDateTimePicker(
      {super.key,
      this.title,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      this.isShowSeconds,
      this.is24HourMode,
      this.minutesInterval,
      this.secondsInterval,
      this.isForce2Digits,
      this.borderRadius,
      this.constraints,
      required this.type,
      this.selectableDayPredicate});

  final String? title;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final bool? isForce2Digits;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final OmniDateTimePickerType type;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: Theme.of(context).useMaterial3
          ? null
          : borderRadius != null
              ? RoundedRectangleBorder(
                  borderRadius: borderRadius!,
                )
              : null,
      child: OmniDtpBasic(
        title: title,
        // textStyle: textStyle,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        is24HourMode: is24HourMode,
        isShowSeconds: isShowSeconds,
        minutesInterval: minutesInterval,
        secondsInterval: secondsInterval,
        isForce2Digits: isForce2Digits,
        constraints: constraints,
        type: type,
        selectableDayPredicate: selectableDayPredicate,
      ),
    );
  }
}
