<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Omni DateTime Picker

[![pub package](https://img.shields.io/pub/v/omni_datetime_picker.svg)](https://pub.dev/packages/omni_datetime_picker)

A DateTime picker that lets user select a date and the time, with start & end as a range.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X2YYHL7)

## Screenshots

|                                                                    Light                                                                     |                                                                    Dark                                                                    |
| :------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------: |
| ![Omni DateTime Range Picker - Light](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/lightmode_v2.png) | ![Omni DateTime Range Picker - Dark](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/darkmode_v2.png) |

## Getting started

Add this to your package's pubspec.yaml file and run `flutter pub get`:

```yaml
dependencies:
  omni_datetime_picker: ^2.0.5
```

Now in your Dart code, you can use:

```dart
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
```

## Usage

Simple usage:

OmniDateTimePicker

```dart
DateTime? dateTime = await showOmniDateTimePicker(context: context);
```

OmniDateTimeRangePicker

```dart
List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(context: context);
```

Custom properties:

OmniDateTimePicker

```dart
DateTime? dateTime = await showOmniDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    lastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    secondsInterval: 1,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 650,
                    ),
                    transitionBuilder: (context, anim1, anim2, child) {
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
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    selectableDayPredicate: (dateTime) {
                      // Disable 25th Feb 2023
                      if (dateTime == DateTime(2023, 2, 25)) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                  );
```

OmniDateTimeRangePicker

```dart
List<DateTime>? dateTimeList =
                      await showOmniDateTimeRangePicker(
                    context: context,
                    startInitialDate: DateTime.now(),
                    startFirstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    startLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    endInitialDate: DateTime.now(),
                    endFirstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    endLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    secondsInterval: 1,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 650,
                    ),
                    transitionBuilder: (context, anim1, anim2, child) {
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
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    selectableDayPredicate: (dateTime) {
                      // Disable 25th Feb 2023
                      if (dateTime == DateTime(2023, 2, 25)) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                  );
```

The returned value of showOmniDateTimeRangePicker() will be a List<DateTime> with two DateTime:

```dart
[startDateTime, endDateTime].
```

## Usage with more flexibility

`OmniDateTimePicker` is now available for use directly as a widget instead of the prebuilt dialogs.
