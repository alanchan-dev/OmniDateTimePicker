import 'package:flutter/material.dart';
import 'flutter_calendar.dart' as cdp;

class Calendar extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime) onDateChanged;
  final bool Function(DateTime)? selectableDayPredicate;

  const Calendar({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.selectableDayPredicate,
  });

  @override
  Widget build(BuildContext context) {
    return cdp.CalendarDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateChanged: onDateChanged,
      selectableDayPredicate: selectableDayPredicate,
    );
  }
}
