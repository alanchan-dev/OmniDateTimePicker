import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
/// We can remove this and use the regular API when you no longer
/// need to support versions of Flutter before 3.0.0,
T? _ambiguate<T>(T? value) => value;

class ItemScrollPhysics extends ScrollPhysics {
  /// Creates physics for snapping to item.
  /// Based on PageScrollPhysics
  final double? itemHeight;
  final double targetPixelsLimit;
  final double? Function(ScrollPosition position)? customTarget;

  const ItemScrollPhysics({
    ScrollPhysics? parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
    this.customTarget,
  }) : super(parent: parent);

  @override
  ItemScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ItemScrollPhysics(
      parent: buildParent(ancestor),
      targetPixelsLimit: targetPixelsLimit,
      itemHeight: itemHeight,
      customTarget: customTarget,
    );
  }

  double _getItem(ScrollPosition position, [double? pixels]) {
    double maxScrollItem =
        (position.maxScrollExtent / itemHeight!).floorToDouble();
    return min(
        max(0, (pixels ?? position.pixels) / itemHeight!), maxScrollItem);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight!;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    final newPixels = customTarget?.call(position);
    double item = _getItem(position, newPixels);
    if (velocity < -tolerance.velocity) {
      item -= targetPixelsLimit;
    } else if (velocity > tolerance.velocity) {
      item += targetPixelsLimit;
    }

    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    Tolerance tolerance = toleranceFor(position);
    final double target =
        _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

typedef SelectedIndexCallback = void Function(int?);
typedef TimePickerCallback = void Function(DateTime);
typedef ShouldDisableItem = bool Function(int, DateTime);

class TimePickerSpinner extends StatefulWidget {
  final DateTime? time;
  final int minutesInterval;
  final int secondsInterval;
  final bool is24HourMode;
  final bool isShowSeconds;
  final double? itemHeight;
  final double? itemWidth;
  final AlignmentGeometry? alignment;
  final double? spacing;
  final bool isForce2Digits;
  final TimePickerCallback onTimeChange;
  final String? pmText;
  final String? amText;
  final ValueNotifier<DateTime>? dynamicSelectedStartDate;
  final ValueNotifier<DateTime>? dynamicSelectedEndDate;

  const TimePickerSpinner({
    Key? key,
    this.time,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.is24HourMode = true,
    this.isShowSeconds = false,
    this.itemHeight,
    this.itemWidth,
    this.alignment,
    this.spacing,
    this.isForce2Digits = false,
    required this.onTimeChange,
    this.pmText,
    this.amText,
    this.dynamicSelectedStartDate,
    this.dynamicSelectedEndDate,
  }) : super(key: key);

  @override
  State<TimePickerSpinner> createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();
  ScrollController secondController = ScrollController();
  ScrollController apController = ScrollController();
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int currentSelectedAPIndex = -1;
  DateTime? currentTime;
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;
  bool isAPScrolling = false;
  double defaultItemHeight = 60;
  double defaultItemWidth = 45;
  double defaultSpacing = 20;
  AlignmentGeometry defaultAlignment = Alignment.center;

  int _getHourCount() {
    return widget.is24HourMode ? 24 : 12;
  }

  int _getMinuteCount() {
    return (60 / widget.minutesInterval).floor();
  }

  int _getSecondCount() {
    return (60 / widget.secondsInterval).floor();
  }

  double _getItemHeight() {
    return widget.itemHeight ?? defaultItemHeight;
  }

  double _getItemWidth() {
    return widget.itemWidth ?? defaultItemWidth;
  }

  double _getSpacing() {
    return widget.spacing ?? defaultSpacing;
  }

  AlignmentGeometry _getAlignment() {
    return widget.alignment ?? defaultAlignment;
  }

  bool isLoop(int value) {
    return value > 10;
  }

  int get currentHour => (currentSelectedHourIndex -
      _getHourCount() +
      (!widget.is24HourMode && currentSelectedAPIndex == 2 ? 12 : 0));
  int get currentMinute =>
      (currentSelectedMinuteIndex -
          (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1)) *
      widget.minutesInterval;
  int get currentSecond =>
      (currentSelectedSecondIndex -
          (isLoop(_getSecondCount()) ? _getSecondCount() : 1)) *
      widget.secondsInterval;

  DateTime getDateTime() {
    int hour = currentSelectedHourIndex - _getHourCount();
    if (!widget.is24HourMode && currentSelectedAPIndex == 2) hour += 12;
    int minute = (currentSelectedMinuteIndex -
            (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1)) *
        widget.minutesInterval;
    int second = (currentSelectedSecondIndex -
            (isLoop(_getSecondCount()) ? _getSecondCount() : 1)) *
        widget.secondsInterval;
    return DateTime(currentTime!.year, currentTime!.month, currentTime!.day,
        hour, minute, second);
  }

  void handleStartTimeChange() {
    final selectedStartDateTime = widget.dynamicSelectedStartDate?.value;
    final selectedEndDateTime = widget.dynamicSelectedEndDate?.value;
    if (selectedStartDateTime == null || selectedEndDateTime == null) return;

    if (selectedStartDateTime.year == selectedEndDateTime.year &&
        selectedStartDateTime.month == selectedEndDateTime.month &&
        selectedStartDateTime.day == selectedEndDateTime.day) {
      if (selectedEndDateTime.isBefore(selectedStartDateTime)) {
        setState(() {
          currentSelectedHourIndex =
              (selectedStartDateTime.hour % _getHourCount()) + _getHourCount();
          hourController
              .jumpTo((currentSelectedHourIndex - 1) * _getItemHeight());
          isHourScrolling = false;

          currentSelectedMinuteIndex =
              (selectedStartDateTime.minute / widget.minutesInterval).floor() +
                  (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1);
          minuteController
              .jumpTo((currentSelectedMinuteIndex - 1) * _getItemHeight());
          isMinuteScrolling = false;

          if (widget.isShowSeconds) {
            currentSelectedSecondIndex =
                (selectedStartDateTime.second / widget.secondsInterval)
                        .floor() +
                    (isLoop(_getSecondCount()) ? _getSecondCount() : 1);
            secondController
                .jumpTo((currentSelectedSecondIndex - 1) * _getItemHeight());
            isSecondsScrolling = false;
          }

          if (!widget.is24HourMode) {
            currentSelectedAPIndex = currentTime!.hour >= 12 ? 2 : 1;
            apController
                .jumpTo((currentSelectedAPIndex - 1) * _getItemHeight());
            isAPScrolling = false;
          }

          widget.onTimeChange(getDateTime());
        });
      }
    }
  }

  void handleEndTimeChange() {
    final selectedStartDateTime = widget.dynamicSelectedStartDate?.value;
    final selectedEndDateTime = widget.dynamicSelectedEndDate?.value;
    if (selectedStartDateTime == null || selectedEndDateTime == null) return;

    if (selectedStartDateTime.year == selectedEndDateTime.year &&
        selectedStartDateTime.month == selectedEndDateTime.month &&
        selectedStartDateTime.day == selectedEndDateTime.day) {
      // Ping the controllers so they update their positions if they need to
      hourController.jumpTo(hourController.offset);
      minuteController.jumpTo(minuteController.offset);

      if (widget.isShowSeconds) {
        secondController.jumpTo(secondController.offset);
      }

      if (!widget.is24HourMode) {
        apController.jumpTo(apController.offset);
      }
    }
  }

  @override
  void initState() {
    currentTime = widget.time ?? DateTime.now();

    widget.dynamicSelectedStartDate?.addListener(handleStartTimeChange);

    if (widget.dynamicSelectedStartDate != null) {
      currentTime = widget.dynamicSelectedStartDate!.value;
    }

    currentSelectedHourIndex =
        (currentTime!.hour % _getHourCount()) + _getHourCount();
    hourController = ScrollController(
        initialScrollOffset: (currentSelectedHourIndex - 1) * _getItemHeight());

    currentSelectedMinuteIndex =
        (currentTime!.minute / widget.minutesInterval).floor() +
            (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1);
    minuteController = ScrollController(
        initialScrollOffset:
            (currentSelectedMinuteIndex - 1) * _getItemHeight());

    currentSelectedSecondIndex =
        (currentTime!.second / widget.secondsInterval).floor() +
            (isLoop(_getSecondCount()) ? _getSecondCount() : 1);
    secondController = ScrollController(
        initialScrollOffset:
            (currentSelectedSecondIndex - 1) * _getItemHeight());

    currentSelectedAPIndex = currentTime!.hour >= 12 ? 2 : 1;
    apController = ScrollController(
        initialScrollOffset: (currentSelectedAPIndex - 1) * _getItemHeight());

    widget.dynamicSelectedEndDate?.addListener(handleEndTimeChange);

    super.initState();

    _ambiguate(WidgetsBinding.instance)!
        .addPostFrameCallback((_) => widget.onTimeChange(getDateTime()));
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    apController.dispose();
    widget.dynamicSelectedStartDate?.removeListener(handleStartTimeChange);
    widget.dynamicSelectedEndDate?.removeListener(handleEndTimeChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          hourController,
          _getHourCount(),
          currentSelectedHourIndex,
          isHourScrolling,
          1,
          (index) {
            bool needChange =
                index != currentSelectedHourIndex || isHourScrolling != true;
            if (needChange) {
              setState(() {
                if (index != null) {
                  currentSelectedHourIndex = index;
                }

                isHourScrolling = true;
              });
            }
          },
          () {
            if (isHourScrolling) {
              setState(() {
                isHourScrolling = false;
              });
            }
          },
          (hour, selectedStartDate) {
            int realHour = widget.is24HourMode
                ? hour
                : (currentSelectedAPIndex == 2 ? hour + 12 : hour);
            if (realHour == 24) {
              realHour = 0;
            }

            return realHour < selectedStartDate.hour;
          },
        ),
      ),
      spacer(),
      SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          minuteController,
          _getMinuteCount(),
          currentSelectedMinuteIndex,
          isMinuteScrolling,
          widget.minutesInterval,
          (index) {
            bool needChange = index != currentSelectedMinuteIndex ||
                isMinuteScrolling != true;
            if (needChange) {
              setState(() {
                if (index != null) {
                  currentSelectedMinuteIndex = index;
                }

                isMinuteScrolling = true;
              });
            }
          },
          () {
            if (isMinuteScrolling) {
              setState(() {
                isMinuteScrolling = false;
              });
            }
          },
          (minute, selectedStartDate) {
            if (currentHour <= selectedStartDate.hour) {
              return minute < selectedStartDate.minute;
            }

            return false;
          },
        ),
      ),
    ];

    if (widget.isShowSeconds) {
      contents.add(spacer());
      contents.add(SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          secondController,
          _getSecondCount(),
          currentSelectedSecondIndex,
          isSecondsScrolling,
          widget.secondsInterval,
          (index) {
            bool needChange = index != currentSelectedSecondIndex ||
                isSecondsScrolling != true;
            if (needChange) {
              setState(() {
                if (index != null) {
                  currentSelectedSecondIndex = index;
                }

                isSecondsScrolling = true;
              });
            }
          },
          () {
            if (isSecondsScrolling) {
              setState(() {
                isSecondsScrolling = false;
              });
            }
          },
          (second, selectedStartDate) {
            if (currentHour <= selectedStartDate.hour &&
                currentMinute <= selectedStartDate.minute) {
              return second < selectedStartDate.second;
            }

            return false;
          },
        ),
      ));
    }

    if (!widget.is24HourMode) {
      contents.add(spacer());
      contents.add(SizedBox(
        width: _getItemWidth() * 1.2,
        height: _getItemHeight() * 3,
        child: apSpinner(),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  Widget spacer() {
    return SizedBox(
      width: _getSpacing(),
      height: _getItemHeight() * 3,
    );
  }

  int getItemNumber(
      ScrollController controller, int index, int max, int interval) {
    int numb = 0;
    if (isLoop(max)) {
      numb = ((index % max) * interval);
    } else if (index != 0 && index != max + 1) {
      numb = (((index - 1) % max) * interval);
    }

    if (!widget.is24HourMode && controller == hourController && numb == 0) {
      numb = 12;
    }

    return numb;
  }

  int? findClosestEnabled(
    double selected,
    DateTime startDate,
    ShouldDisableItem shouldDisableItem, {
    required int scrollMax,
    required int max,
    required int interval,
    required ScrollController controller,
  }) {
    int lower = selected.floor();
    int upper = selected.ceil();

    for (;;) {
      if (lower < 1 && upper >= scrollMax) return null;

      if (lower >= 0 &&
          !shouldDisableItem(
              getItemNumber(controller, lower, max, interval), startDate))
        return lower;
      if (upper < scrollMax &&
          !shouldDisableItem(
              getItemNumber(controller, upper, max, interval), startDate))
        return upper;

      lower = (lower - 1);
      upper = (upper + 1);
    }
  }

  Widget spinner(
    ScrollController controller,
    int max,
    int selectedIndex,
    bool isScrolling,
    int interval,
    SelectedIndexCallback onUpdateSelectedIndex,
    VoidCallback onScrollEnd,
    ShouldDisableItem shouldDisableItem,
  ) {
    /// wrapping the spinner with stack and add container above it when it's scrolling
    /// this thing is to prevent an error causing by some weird stuff like this
    /// flutter: Another exception was thrown: 'package:flutter/src/widgets/scrollable.dart': Failed assertion: line 469 pos 12: '_hold == null || _drag == null': is not true.
    /// maybe later we can find out why this error is happening

    buildList([DateTime? selectedStartDate, DateTime? selectedEndDate]) =>
        ListView.builder(
          itemBuilder: (context, index) {
            final itemNumber = getItemNumber(controller, index, max, interval);
            String text = itemNumber.round().toString();
            if (widget.isForce2Digits && text != '') {
              text = text.padLeft(2, '0');
            }

            TextStyle style = (selectedIndex == index
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context).textTheme.bodyLarge) ??
                const TextStyle();

            if (selectedStartDate != null &&
                selectedEndDate != null &&
                selectedStartDate.year == selectedEndDate.year &&
                selectedStartDate.month == selectedEndDate.month &&
                selectedStartDate.day == selectedEndDate.day &&
                shouldDisableItem(itemNumber, selectedStartDate)) {
              style = style.copyWith(color: Theme.of(context).disabledColor);
            }

            return Container(
              height: _getItemHeight(),
              alignment: _getAlignment(),
              child: AnimatedDefaultTextStyle(
                style: style,
                duration: const Duration(milliseconds: 250),
                child: Text(text),
              ),
            );
          },
          controller: controller,
          itemCount: isLoop(max) ? max * 3 : max + 2,
          physics: ItemScrollPhysics(
            customTarget: (position) {
              final itemPosition = (position.pixels / _getItemHeight()) + 1;
              final itemNumber = getItemNumber(
                  controller, itemPosition.round(), max, interval);

              if (widget.dynamicSelectedStartDate != null &&
                  widget.dynamicSelectedEndDate != null &&
                  widget.dynamicSelectedStartDate!.value.year ==
                      widget.dynamicSelectedEndDate!.value.year &&
                  widget.dynamicSelectedStartDate!.value.month ==
                      widget.dynamicSelectedEndDate!.value.month &&
                  widget.dynamicSelectedStartDate!.value.day ==
                      widget.dynamicSelectedEndDate!.value.day &&
                  shouldDisableItem(
                      itemNumber, widget.dynamicSelectedStartDate!.value)) {
                final closedEnabledPosition = findClosestEnabled(
                  itemPosition,
                  widget.dynamicSelectedStartDate!.value,
                  shouldDisableItem,
                  scrollMax: isLoop(max) ? max * 3 : max + 2,
                  max: max,
                  interval: interval,
                  controller: controller,
                );

                if (closedEnabledPosition != null) {
                  return (closedEnabledPosition - 1) * _getItemHeight();
                }
              }

              return null;
            },
            itemHeight: _getItemHeight(),
          ),
          padding: EdgeInsets.zero,
        );

    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() ==
              "ScrollDirection.idle") {
            if (isLoop(max)) {
              int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller.jumpTo(controller.offset + (max * _getItemHeight()));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller.jumpTo(controller.offset - (max * _getItemHeight()));
              }
            }

            onScrollEnd();
            widget.onTimeChange(getDateTime());
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          final i = (controller.offset / _getItemHeight()).round() + 1;

          if (widget.dynamicSelectedStartDate == null ||
              !shouldDisableItem(getItemNumber(controller, i, max, interval),
                  widget.dynamicSelectedStartDate!.value)) {
            onUpdateSelectedIndex(i);
          } else {
            onUpdateSelectedIndex(null);
          }
        } else if (scrollNotification is ScrollEndNotification) {
          onScrollEnd();
        }

        return true;
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: widget.dynamicSelectedStartDate != null &&
                widget.dynamicSelectedEndDate != null
            ? ValueListenableBuilder(
                valueListenable: widget.dynamicSelectedStartDate!,
                builder: (context, startDate, __) {
                  return ValueListenableBuilder(
                    valueListenable: widget.dynamicSelectedEndDate!,
                    builder: (context, selectedDate, _) =>
                        buildList(startDate, selectedDate),
                  );
                },
              )
            : buildList(),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isScrolling
            ? Positioned.fill(
                child: Container(
                color: Colors.black.withOpacity(0),
              ))
            : Container()
      ],
    );
  }

  bool isMeridianDisabled(int index,
      [DateTime? selectedStartDate, DateTime? selectedLastDate]) {
    if (selectedStartDate == null || selectedLastDate == null) return false;

    return (selectedStartDate.year == selectedLastDate.year &&
        selectedStartDate.month == selectedLastDate.month &&
        selectedStartDate.day == selectedLastDate.day &&
        selectedStartDate.hour >= 12 &&
        index != 2 &&
        !widget.is24HourMode);
  }

  Widget apSpinner() {
    buildList([DateTime? selectedStartDate, DateTime? selectedEndDate]) =>
        ListView.builder(
          itemBuilder: (context, index) {
            String text = index == 1
                ? widget.amText ?? 'AM'
                : (index == 2 ? widget.pmText ?? 'PM' : '');
            TextStyle style = (currentSelectedAPIndex == index
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context).textTheme.bodyLarge) ??
                const TextStyle();

            if (isMeridianDisabled(index, selectedStartDate, selectedEndDate)) {
              style = style.copyWith(color: Theme.of(context).disabledColor);
            }

            return Container(
              height: _getItemHeight(),
              alignment: Alignment.center,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: style,
                child: Text(
                  text,
                ),
              ),
            );
          },
          controller: apController,
          itemCount: 4,
          physics: ItemScrollPhysics(
            customTarget: (position) {
              if (isMeridianDisabled(
                (position.pixels / _getItemHeight()).round() + 1,
                widget.dynamicSelectedStartDate?.value,
                widget.dynamicSelectedEndDate?.value,
              )) {
                return (2 * _getItemHeight());
              }

              return null;
            },
            itemHeight: _getItemHeight(),
            targetPixelsLimit: 1,
          ),
          padding: EdgeInsets.zero,
        );

    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.idle) {
            isAPScrolling = false;
            widget.onTimeChange(getDateTime());
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          final newCurrentSelectedAPIndex =
              (apController.offset / _getItemHeight()).round() + 1;

          if (isAPScrolling != true ||
              currentSelectedAPIndex != newCurrentSelectedAPIndex) {
            setState(() {
              currentSelectedAPIndex = newCurrentSelectedAPIndex;
              isAPScrolling = true;
            });
          }
        }

        return true;
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: widget.dynamicSelectedStartDate != null &&
                widget.dynamicSelectedEndDate != null
            ? ValueListenableBuilder(
                valueListenable: widget.dynamicSelectedStartDate!,
                builder: (context, startDate, __) {
                  return ValueListenableBuilder(
                    valueListenable: widget.dynamicSelectedEndDate!,
                    builder: (context, selectedDate, _) =>
                        buildList(startDate, selectedDate),
                  );
                },
              )
            : buildList(),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isAPScrolling ? Positioned.fill(child: Container()) : Container()
      ],
    );
  }
}
