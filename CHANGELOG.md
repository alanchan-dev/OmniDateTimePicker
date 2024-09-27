## 2.0.5

- Update: rxdart version to 0.28.0

## 2.0.4

- Fix: "Seconds" field displays "Minutes" information (#68)

## 2.0.3

- Fix: Overflow issue on very small screen

## 2.0.2

- Fix: `constraints` on single date time picker (#61)

## 2.0.1

- Fix: Issue #57 #58
- Fix: `constraints` not working correctly
- Add: `barrierColor` to prebuilt dialogs
- Lower Dart SDK constraint to >= 3.4.0

## 2.0.0

- Breaking: `DefaultView` enum is now `DefaultTab`
- Breaking: `separator` is now split into `titleSeparator` (The widget after title, only shows if `title` is non-null) and `separator` (The widget between Date and Time)
- Breaking: `constraints` are now default to `BoxConstraints.expand()` if null.
- Breaking: Disabled swipe to change tabs for OmniDateTimeRangePicker.
- Fix: TimePickerSpinner is now left to right regardless of language
- Add: `selectionOverlay` to customize TimePickerSpinner selected time
- Add: `time` option to `OmniDateTimePickerType` enum
- Add: `onStartDateAfterEndDateError` is a function that runs if `isForceEndDateAfterStartDate` is true and the selectedStartDate is after selectedEndDate. (Only for range picker)
- Add: `padding` option to dialog
- Add: `insetPadding` option to dialog
- Add: `startLabelWidget` and `endLabelWidget` to have custom tab titles (#48)
- Add: Direct usage of `OmniDateTimePicker` without using it as dialog, by using `onDateTimeChanged` for more flexibility. (#38)

## 1.1.0

- Add: isForceEndDateAfterStartDate option to showOmniDateTimeRangePicker

## 1.0.9

- Fix: dart formatting

## 1.0.8

- Added DefaultView to choose which tab to open by default for showOmniDateTimeRangePicker (#35)
- Added optional title and divider arguments to showOmniDateTimePicker (#39)

## 1.0.7

- Add: theme property that accepts a ThemeData to customize the look of the picker regardless of the app's theme.

## 1.0.6

- Fix: is24HourMode not working on OmniDateTimeRangePicker

## 1.0.5

- Add: isForce2Digits property to force 2 digits on TimeSpinner

## 1.0.4+1

- Update: ReadMe

## 1.0.4

- Fix: Issue #27

## 1.0.3

- Fix: minuteInterval property does not working on the OmniDateTimeRangePicker

## 1.0.2

- Fix: initialDate not taking effect on the time spinner

## 1.0.1

- Fix: Set padding of \_DayPicker's GridView to 0 to prevent some days being cut off.

## 1.0.0

- Breaking: Styling fields (colors, text style), Theme widget can be used to have a more consistent design
- Breaking: borderRadius now requires a BorderRadiusGeometry instead of double for more control over the look (borderRadius won't have effect if useMaterial3 is true)
- Add: Preserve state when switching tabs using OmniDateTimeRangePicker
- Add: Constraints can now be passed to limit the size, else a preferred default value will be used
- Add: Expose selectableDayPredicate to let user disable certain day
- Add: transitionBuilder & transitionDuration field to customize animation of dialog
- Fix: AM PM offset not aligned correctly in mobile

## 0.2.0+1

- Fixed Changelog mistake

## 0.2.0

- Flutter 2.10 and above is required
- Fixed borderRadius issue in OmniDateTimePicker
- Support for Material3, just set useMaterial3 in your app's theme and it will work.
- Readme update (Overhaul planned)

## 0.1.4

- Use drag scroll on web (same behavior as mobile)
- Removed scrollbar on web

## 0.1.3

- Use Custom TabView
- Expose minutesInterval and localize am-pm

## 0.1.2

- Tweak UI spacing
- Updated documents

## 0.1.1

- Added type to only use Date without Time

## 0.1.0

- Enables backward compatibility with Flutter versions prior to v3.0 by using ambiguate

## 0.0.9

- Fixed for Flutter 3.0
- Fixed overflow when opening

## 0.0.8

Removed unused properties.

## 0.0.7

Fixed overflow issue on smaller device.

## 0.0.6

Fixed breaking error from 0.0.5.

## 0.0.5+1

Updated README typo

## 0.0.5

Replace hardcoded text values by localized defaults

## 0.0.4+1

Updated homepage and repository link

## 0.0.4

Fixed time spinner alignment issue.

## 0.0.3+1

Fixed bug where TimeSpinner is not showing passed startDateTime

## 0.0.3

Fixed bug where initial DateTime not being used.

## 0.0.2+2

Update readme

## 0.0.2+1

Update pubspec.yaml

## 0.0.2

Update pubspec.yaml

## 0.0.1

Initial release.
