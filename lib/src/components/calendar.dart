import 'package:flutter/material.dart';
import 'calendar_date_picker.dart' as cdp;

class Calendar extends StatelessWidget {
  const Calendar(
      {super.key,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      required this.onDateChanged,
      this.selectableDayPredicate});

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime) onDateChanged;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    final defaultInitialDate = DateTime.now();
    final defaultFirstDate = DateTime.fromMillisecondsSinceEpoch(0);
    final defaultLastDate = DateTime.now().add(const Duration(days: 3652));

    return cdp.CalendarDatePicker(
      initialDate: initialDate ?? defaultInitialDate,
      firstDate: firstDate ?? defaultFirstDate,
      lastDate: lastDate ?? defaultLastDate,
      onDateChanged: onDateChanged,
      selectableDayPredicate: selectableDayPredicate,
    );
  }
}
