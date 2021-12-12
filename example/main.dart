import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni DateTime Picker',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  DateTime? dateTime =
                      await showOmniDateTimePicker(context: context);
                },
                child: const Text("Show DateTime Picker"),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<DateTime>? dateTimeList =
                      await showOmniDateTimeRangePicker(
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
                    endFirstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    endLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    borderRadius: const Radius.circular(16),
                  );
                },
                child: const Text("Show DateTime Range Picker"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
