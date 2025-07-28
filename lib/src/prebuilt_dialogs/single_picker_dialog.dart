import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/button_row.dart';
import '../enums/omni_datetime_picker_type.dart';
import '../omni_datetime_picker.dart';

class SinglePickerDialog extends StatefulWidget {
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

  final ButtonRowBuilder? actionsBuilder;

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
    this.actionsBuilder,
  });

  @override
  State<SinglePickerDialog> createState() => _SinglePickerDialogState();
}

class _SinglePickerDialogState extends State<SinglePickerDialog> {
  late DateTime? selectedDateTime;
  bool canSave = true; // Default to true, will be updated by callback

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      insetPadding: widget.insetPadding,
      shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(Radius.circular(16))),
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints.tightFor(),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null) widget.title!,
              if (widget.title != null && widget.titleSeparator != null)
                widget.titleSeparator!,
              Flexible(
                child: SingleChildScrollView(
                  child: OmniDateTimePicker(
                    onDateTimeChanged: (dateTime) {
                      selectedDateTime = dateTime;
                    },
                    onCanSaveChanged: (canSaveValue) {
                      setState(() {
                        canSave = canSaveValue;
                      });
                    },
                    initialDate: widget.initialDate ?? widget.firstDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    amText: widget.amText,
                    pmText: widget.pmText,
                    isShowSeconds: widget.isShowSeconds ?? false,
                    is24HourMode: widget.is24HourMode ?? false,
                    minutesInterval: widget.minutesInterval ?? 1,
                    secondsInterval: widget.secondsInterval ?? 1,
                    isForce2Digits: widget.isForce2Digits ?? true,
                    looping: widget.looping ?? true,
                    selectionOverlay: widget.selectionOverlay ??
                        const CupertinoPickerDefaultSelectionOverlay(),
                    separator: widget.separator,
                    type: widget.type ?? OmniDateTimePickerType.dateAndTime,
                  ),
                ),
              ),
              ButtonRow(
                actionsBuilder: widget.actionsBuilder,
                onCancelPressed: () {
                  Navigator.of(context).pop<DateTime>();
                },
                onSavePressed: canSave
                    ? () {
                        Navigator.pop<DateTime>(
                          context,
                          selectedDateTime,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
