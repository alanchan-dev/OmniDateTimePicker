import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/src/time_picker_spinner.dart';

/// Omni DateTimeRange Picker
///
/// If properties are not given, default value will be used.
class OmniDateTimeRangePicker extends StatefulWidget {
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

  /// End initial datetime
  ///
  /// Default value: DateTime.now().add(const Duration(days: 1))
  final DateTime? endInitialDate;

  /// Minimum date that can be selected
  ///
  /// Default value: DateTime.now().subtract(const Duration(days: 3652))
  final DateTime? endFirstDate;

  /// Maximum date that can be selected
  ///
  /// Default value: DateTime.now().add(const Duration(days: 3652))
  final DateTime? endLastDate;

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

  const OmniDateTimeRangePicker({
    Key? key,
    this.startInitialDate,
    this.startFirstDate,
    this.startLastDate,
    this.endInitialDate,
    this.endFirstDate,
    this.endLastDate,
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
  }) : super(key: key);

  @override
  State<OmniDateTimeRangePicker> createState() =>
      _OmniDateTimeRangePickerState();
}

class _OmniDateTimeRangePickerState extends State<OmniDateTimeRangePicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// startDateTime will be returned in a List<DateTime> with index 0
  ///
  /// Initial value: Current DateTime
  DateTime startDateTime = DateTime.now();

  /// endDateTime will be returned in a List<DateTime> with index 1
  ///
  /// Initial value: 1 day after current DateTime
  DateTime endDateTime = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              padding: const EdgeInsets.all(0),
              labelPadding: const EdgeInsets.all(0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: widget.backgroundColor ?? Colors.white,
              indicatorWeight: 0.1,
              tabs: [
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: _tabController.index == 0
                          ? widget.backgroundColor ?? Colors.white
                          : widget.unselectedTabBackgroundColor ??
                              Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft:
                            widget.borderRadius ?? const Radius.circular(16),
                        topRight:
                            widget.borderRadius ?? const Radius.circular(16),
                      )),
                  child: Text(
                    "Start",
                    style:
                        TextStyle(color: widget.tabTextColor ?? Colors.black87),
                  ),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? widget.backgroundColor ?? Colors.white
                          : widget.unselectedTabBackgroundColor ??
                              Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft:
                            widget.borderRadius ?? const Radius.circular(16),
                        topRight:
                            widget.borderRadius ?? const Radius.circular(16),
                      )),
                  child: Text(
                    "End",
                    style:
                        TextStyle(color: widget.tabTextColor ?? Colors.black87),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                ),
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    /// Start date
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CalendarDatePicker(
                          initialDate:
                              widget.startInitialDate ?? DateTime.now(),
                          firstDate: widget.startFirstDate ??
                              DateTime.now()
                                  .subtract(const Duration(days: 3652)),
                          lastDate: widget.startLastDate ??
                              DateTime.now().add(const Duration(days: 3652)),
                          onDateChanged: (dateTime) {
                            startDateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              startDateTime.hour,
                              startDateTime.minute,
                            );
                          },
                        ),
                        TimePickerSpinner(
                          is24HourMode: widget.is24HourMode ?? false,
                          isShowSeconds: widget.isShowSeconds ?? false,
                          normalTextStyle: widget.timeSpinnerTextStyle ??
                              TextStyle(
                                  fontSize: 18,
                                  color: widget.calendarTextColor ??
                                      Colors.black54),
                          highlightedTextStyle: widget
                                  .timeSpinnerHighlightedTextStyle ??
                              TextStyle(
                                  fontSize: 24,
                                  color:
                                      widget.calendarTextColor ?? Colors.black),
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
                      ],
                    ),

                    /// End date
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CalendarDatePicker(
                          initialDate: widget.endInitialDate ??
                              DateTime.now().add(const Duration(days: 1)),
                          firstDate: widget.endFirstDate ??
                              DateTime.now()
                                  .subtract(const Duration(days: 3652)),
                          lastDate: widget.endLastDate ??
                              DateTime.now().add(const Duration(days: 3652)),
                          onDateChanged: (dateTime) {
                            endDateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              endDateTime.hour,
                              endDateTime.minute,
                            );
                          },
                        ),
                        TimePickerSpinner(
                          is24HourMode: widget.is24HourMode ?? false,
                          isShowSeconds: widget.isShowSeconds ?? false,
                          normalTextStyle: widget.timeSpinnerTextStyle ??
                              TextStyle(
                                  fontSize: 18,
                                  color: widget.calendarTextColor ??
                                      Colors.black54),
                          highlightedTextStyle: widget
                                  .timeSpinnerHighlightedTextStyle ??
                              TextStyle(
                                  fontSize: 24,
                                  color:
                                      widget.calendarTextColor ?? Colors.black),
                          onTimeChange: (dateTime) {
                            DateTime tempEndDateTime = DateTime(
                              endDateTime.year,
                              endDateTime.month,
                              endDateTime.day,
                              dateTime.hour,
                              dateTime.minute,
                              dateTime.second,
                            );

                            endDateTime = tempEndDateTime;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: widget.borderRadius ?? const Radius.circular(16),
                  bottomRight: widget.borderRadius ?? const Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: widget.borderRadius ?? const Radius.circular(16),
                  bottomRight: widget.borderRadius ?? const Radius.circular(16),
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
                          Navigator.of(context).pop<List<DateTime>>();
                        },
                        child: Text(
                          "Cancel",
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
                          Navigator.pop<List<DateTime>>(context, [
                            startDateTime,
                            endDateTime,
                          ]);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: widget.buttonTextColor ?? Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
