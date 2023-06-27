import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:scheduling/staff_scheduling.dart';
import 'package:scheduling/staff_scheduling_mobile.dart';

void main() => runApp(DevicePreview(
      builder: (context) => const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final staffList = [
      {
        'name': 'John Doe',
        'image': 'https://placebeard.it/640x360',
        'schedule': [
          {
            'day': 'Mon',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 1'
          },
          {
            'day': 'Tue',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 2'
          },
          {
            'day': 'Wed',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 3'
          },
          {
            'day': 'Thu',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 4'
          },
          {
            'day': 'Fri',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 5'
          },
          {
            'day': 'Sat',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
          {
            'day': 'Sun',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
        ],
      },
      {
        'name': 'Jane Smith',
        'image': 'http://placeimg.com/640/360/any',
        'schedule': [
          {
            'day': 'Mon',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
          {
            'day': 'Tue',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 2'
          },
          {
            'day': 'Wed',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 3'
          },
          {
            'day': 'Thu',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
          {
            'day': 'Fri',
            'startTime': '8am',
            'endTime': '4pm',
            'taskName': 'Task 5'
          },
          {
            'day': 'Sat',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
          {
            'day': 'Sun',
            'startTime': 'off',
            'endTime': 'off',
            'taskName': 'off'
          },
        ],
      },
    ];

    return MaterialApp(
      title: 'Staff Schedule',
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 16),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.pinkAccent),
      ),
      home: StaffSchedulingPage(),
    );
  }
}
