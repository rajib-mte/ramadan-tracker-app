import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'home_page.dart';

void main() {
  runApp(const MyApp());

  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Ramadan Tracker App',
      home: HomePage(),
    );
  }
}