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

## Support my passion

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/alanchan)

### Material 3 support

Material 3 is currently supported, set useMaterial3 is true in your app's Theme.

### Changes in version 1.0.0

- Breaking: Styling fields (colors, text style), Theme widget can be used to have a more consistent design
- Breaking: borderRadius now requires a BorderRadiusGeometry instead of double for more control over the look. (borderRadius won't have effect if useMaterial3 is true)
- Add: Preserve state when switching tabs using OmniDateTimeRangePicker
- Add: Constraints can now be passed to limit the size, else a preferred default value will be used
- Add: Expose selectableDayPredicate to let user disable certain day
- Add: transitionBuilder & transitionDuration field to customize animation of dialog
- Fix: AM PM offset not aligned correctly in mobile

Refer to example for usage.

## Screenshots

![Omni DateTime Range Picker - Material 3 Light](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/m3_lightmode_v1.png)

![Omni DateTime Range Picker - Material 3 Dark](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/m3_darkmode_v1.png)

## Getting started

Add this to your package's pubspec.yaml file and run `flutter pub get`:

```yaml
dependencies:
  omni_datetime_picker: ^1.0.4
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
