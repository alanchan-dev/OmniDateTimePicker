import 'package:flutter/material.dart';

import 'enums/default_tab.dart';
import 'enums/omni_datetime_picker_type.dart';
import 'prebuilt_dialogs/range_picker_dialog.dart';
import 'prebuilt_dialogs/single_picker_dialog.dart';

/// Show dialog of the [OmniDateTimePicker]
///
/// Returns a DateTime
///
Future<DateTime?> showOmniDateTimePicker({
  required BuildContext context,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
  Duration? transitionDuration,
  bool? barrierDismissible,
  Color? barrierColor,
  Widget? title,
  Widget? titleSeparator,
  Widget? separator,
  OmniDateTimePickerType type = OmniDateTimePickerType.dateAndTime,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  bool? is24HourMode,
  bool? isShowSeconds,
  int? minutesInterval,
  int? secondsInterval,
  bool? isForce2Digits,
  bool Function(DateTime)? selectableDayPredicate,
  BorderRadiusGeometry? borderRadius,
  EdgeInsets? padding,
  EdgeInsets? insetPadding,
  BoxConstraints? constraints,
  ThemeData? theme,
}) {
  return showGeneralDialog(
    context: context,
    transitionBuilder: transitionBuilder ??
        (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1.drive(
              Tween(
                begin: 0,
                end: 1,
              ),
            ),
            child: child,
          );
        },
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: 'OmniDateTimePicker',
    barrierColor: barrierColor ?? const Color(0x80000000),
    pageBuilder: (context, anim1, anim2) {
      return Theme(
        data: theme ?? Theme.of(context),
        child: SinglePickerDialog(
          title: title,
          titleSeparator: titleSeparator,
          separator: separator,
          type: type,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          is24HourMode: is24HourMode,
          isShowSeconds: isShowSeconds,
          minutesInterval: minutesInterval,
          secondsInterval: secondsInterval,
          isForce2Digits: isForce2Digits,
          borderRadius: borderRadius,
          padding: padding,
          insetPadding: insetPadding,
          selectableDayPredicate: selectableDayPredicate,
          constraints: constraints,
        ),
      );
    },
  );
}

/// Show a dialog of the [OmniDateTimePicker]
///
/// Returns a List<DateTime>
/// with index 0 as startDateTime
/// and index 1 as endDateTime
///
Future<List<DateTime>?> showOmniDateTimeRangePicker({
  required BuildContext context,
  DateTime? startInitialDate,
  DateTime? startFirstDate,
  DateTime? startLastDate,
  DateTime? endInitialDate,
  DateTime? endFirstDate,
  DateTime? endLastDate,
  bool? is24HourMode,
  bool? isShowSeconds,
  int? minutesInterval,
  int? secondsInterval,
  bool? isForce2Digits,
  bool? isForceEndDateAfterStartDate,
  void Function()? onStartDateAfterEndDateError,
  BorderRadiusGeometry? borderRadius,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
  Duration? transitionDuration,
  bool? barrierDismissible,
  Color? barrierColor,
  Widget? title,
  Widget? titleSeparator,
  Widget? startWidget,
  Widget? endWidget,
  Widget? separator,
  OmniDateTimePickerType type = OmniDateTimePickerType.dateAndTime,
  bool Function(DateTime)? startSelectableDayPredicate,
  bool Function(DateTime)? endSelectableDayPredicate,
  DefaultTab defaultTab = DefaultTab.start,
  EdgeInsets? padding,
  EdgeInsets? insetPadding,
  ThemeData? theme,
  BoxConstraints? constraints,
}) {
  return showGeneralDialog(
    context: context,
    transitionBuilder: transitionBuilder ??
        (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1.drive(
              Tween(
                begin: 0,
                end: 1,
              ),
            ),
            child: child,
          );
        },
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: 'OmniDateTimeRangePicker',
    barrierColor: barrierColor ?? const Color(0x80000000),
    pageBuilder: (BuildContext context, anim1, anim2) {
      return Theme(
        data: theme ?? Theme.of(context),
        child: RangePickerDialog(
          title: title,
          titleSeparator: titleSeparator,
          startLabelWidget: startWidget,
          endLabelWidget: endWidget,
          separator: separator,
          type: type,
          startInitialDate: startInitialDate,
          startFirstDate: startFirstDate,
          startLastDate: startLastDate,
          endInitialDate: endInitialDate,
          endFirstDate: endFirstDate,
          endLastDate: endLastDate,
          is24HourMode: is24HourMode,
          isShowSeconds: isShowSeconds,
          minutesInterval: minutesInterval,
          secondsInterval: secondsInterval,
          isForce2Digits: isForce2Digits,
          isForceEndDateAfterStartDate: isForceEndDateAfterStartDate,
          onStartDateAfterEndDateError: onStartDateAfterEndDateError,
          borderRadius: borderRadius,
          padding: padding,
          insetPadding: insetPadding,
          constraints: constraints,
          defaultTab: defaultTab,
          startSelectableDayPredicate: startSelectableDayPredicate,
          endSelectableDayPredicate: endSelectableDayPredicate,
        ),
      );
    },
  );
}
