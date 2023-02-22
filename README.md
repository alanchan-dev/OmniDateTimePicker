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

A DateTime picker that lets user select a date and the time, with start & end as a range.

### Upcoming plan

Currently I plan to rewrite this package by stripping away the fields for passing in colors and textStyles.
In the upcoming major version, you will need to use Theme to customize these.
Version after 1.0 will stop support for these fields.

### Material 3 support

Material 3 is currently supported, if useMaterial3 is true in your app's Theme, passing in colors field will have no effect.

## Screenshots

![Omni DateTime Range Picker - Material 3 Light](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/m3_lightmode.png)

![Omni DateTime Range Picker - Material 3 Dark](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/m3_darkmode.png)

![Omni DateTime Picker - Light](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/screenshot_light.png)

![Omni DateTime Range Picker - Dark](https://raw.githubusercontent.com/alanchan-dev/OmniDateTimePicker/master/screenshots/screenshot_dark.png)

## Getting started

Add this to your package's pubspec.yaml file and run `flutter pub get`:

```yaml
dependencies:
  omni_datetime_picker: ^0.2.0+1
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
              type: OmniDateTimePickerType.dateAndTime,
              primaryColor: Colors.cyan,
              backgroundColor: Colors.grey[900],
              calendarTextColor: Colors.white,
              tabTextColor: Colors.white,
              unselectedTabBackgroundColor: Colors.grey[700],
              buttonTextColor: Colors.white,
              timeSpinnerTextStyle:
                  const TextStyle(color: Colors.white70, fontSize: 18),
              timeSpinnerHighlightedTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 24),
              is24HourMode: false,
              isShowSeconds: false,
              startInitialDate: DateTime.now(),
              startFirstDate:
                  DateTime(1600).subtract(const Duration(days: 3652)),
              startLastDate: DateTime.now().add(
                const Duration(days: 3652),
              ),
              borderRadius: const Radius.circular(16),
            );
```

OmniDateTimeRangePicker

```dart
List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
              context: context,
              type: OmniDateTimePickerType.dateAndTime,
              primaryColor: Colors.cyan,
              backgroundColor: Colors.grey[900],
              calendarTextColor: Colors.white,
              tabTextColor: Colors.white,
              unselectedTabBackgroundColor: Colors.grey[700],
              buttonTextColor: Colors.white,
              timeSpinnerTextStyle:
                  const TextStyle(color: Colors.white70, fontSize: 18),
              timeSpinnerHighlightedTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 24),
              is24HourMode: false,
              isShowSeconds: false,
              startInitialDate: DateTime.now(),
              startFirstDate:
                  DateTime(1600).subtract(const Duration(days: 3652)),
              startLastDate: DateTime.now().add(
                const Duration(days: 3652),
              ),
              endInitialDate: DateTime.now(),
              endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
              endLastDate: DateTime.now().add(
                const Duration(days: 3652),
              ),
              borderRadius: const Radius.circular(16),
            );
```

The returned value of showOmniDateTimeRangePicker() will be a List with two DateTime: [startDateTime, endDateTime].
