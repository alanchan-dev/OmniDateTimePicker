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

## Screenshots

![Omni DateTime Picker - Light](https://raw.githubusercontent.com/DogeeeXD/OmniDateTimePicker/master/screenshots/screenshot_light.png)

![Omni DateTime Range Picker - Dark](https://raw.githubusercontent.com/DogeeeXD/OmniDateTimePicker/master/screenshots/screenshot_dark.png)

## Getting started

Add this to your package's pubspec.yaml file and run `flutter pub get`:

```yaml
dependencies:
  omni_datetime_picker: ^0.0.7
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




<!-- ## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more. -->
