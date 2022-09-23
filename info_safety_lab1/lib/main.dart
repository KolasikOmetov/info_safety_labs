import 'package:flutter/material.dart';
import 'package:info_safety_lab1/pages/entrance_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EntrancePage(),
    );
  }
}
