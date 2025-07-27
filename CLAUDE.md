# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OmniDateTimePicker is a Flutter package that provides customizable date and time picker dialogs. It supports both single date/time selection and date/time range selection with a modern, Material Design interface.

## Development Commands

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

### Getting Dependencies
```bash
flutter pub get
```

### Running Example
```bash
cd example && flutter run
```

### Publishing (for maintainers)
```bash
flutter pub publish --dry-run  # Test publishing
flutter pub publish            # Actual publish
```

## Architecture

### Core Components

- **Main Widget**: `OmniDateTimePicker` in `lib/src/omni_datetime_picker.dart` - The main reusable widget that can be embedded directly in apps
- **Dialog Functions**: `showOmniDateTimePicker()` and `showOmniDateTimeRangePicker()` in `lib/src/omni_datetime_picker_dialogs.dart` - Convenience functions that wrap the widget in dialogs
- **State Management**: Uses BLoC pattern with `flutter_bloc` for managing date/time state and user interactions

### Key Directories

- `lib/src/bloc/` - BLoC classes for state management (main picker and time spinner)
- `lib/src/components/` - Reusable UI components (calendar, time spinner, buttons)
- `lib/src/prebuilt_dialogs/` - Pre-configured dialog wrappers for single and range selection
- `lib/src/enums/` - Type definitions for picker types and default tabs
- `lib/src/utils/` - Utility functions and extensions

### State Management Pattern

The package uses BLoC pattern with two main blocs:
- `OmniDatetimePickerBloc` - Manages overall date/time state
- `TimePickerSpinnerBloc` - Manages time spinner component state

Events are debounced using RxDart to prevent excessive updates during user interaction.

### Dependencies

- `flutter_bloc` - State management
- `equatable` - Value equality for state objects  
- `rxdart` - Reactive extensions for debouncing events

## Code Conventions

- Follow standard Flutter/Dart conventions
- Use BLoC pattern for state management
- Debounce user input events to optimize performance
- Support both 12-hour and 24-hour time formats
- Maintain backward compatibility when making changes
- All public APIs should include comprehensive documentation

## Testing

- Tests are minimal currently (only placeholder in `test/omni_datetime_picker_test.dart`)
- When adding tests, focus on widget behavior and state management
- Use `flutter_test` for widget and unit tests