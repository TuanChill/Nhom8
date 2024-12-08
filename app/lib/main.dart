import 'package:daily_e/src/presentation/layout_app.dart';
import 'package:daily_e/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily E',
      theme: lightMode,
      darkTheme: darkMode,
      home: const LayoutApp(),
    );
  }
}
