import 'package:flutter/material.dart';
import 'package:nutria/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //static const String _title = 'Nutria';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //title: _title,
        home: MainScreen(),
        debugShowCheckedModeBanner: false);
  }
}
