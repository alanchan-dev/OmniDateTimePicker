import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omni DateTime Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
      ),
      home: const OmniExample(),
    );
  }
}

class OmniExample extends StatelessWidget {
  const OmniExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? dateTime =
                    await showOmniDateTimePicker(context: context);

                // Use dateTime here
                debugPrint('dateTime: $dateTime');
              },
              child: const Text('Show DateTime Picker'),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? result = await showOmniDateTimePicker(
                  context: context,
                  is24HourMode: true,
                );

                if (result != null) {
                  // This should show the second and millisecond fields set to zero after the fix
                  debugPrint('Selected DateTime: ${result.toUtc().toIso8601String()}');
                  debugPrint('Seconds: ${result.second}, Milliseconds: ${result.millisecond}');
                }
              },
              child: const Text('Test 24-Hour Mode (check seconds)'),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? result = await showOmniDateTimePicker(
                  context: context,
                  is24HourMode: true,
                  isShowSeconds: true,
                );

                if (result != null) {
                  // This should show microseconds as 0 even when seconds are enabled
                  debugPrint('Selected DateTime with seconds: ${result.toUtc().toIso8601String()}');
                  debugPrint('Seconds: ${result.second}, Microseconds: ${result.microsecond}');
                }
              },
              child: const Text('Test with Seconds (check microseconds)'),
            ),
            ElevatedButton(
              onPressed: () async {
                final List<DateTime>? dateTime =
                    await showOmniDateTimeRangePicker(context: context);

                // Use dateTime here
                debugPrint('dateTime: $dateTime');
              },
              child: const Text('Show DateTime Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
