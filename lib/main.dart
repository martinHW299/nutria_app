import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutria_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:nutria_app/screen/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nutria App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Splash()
      ),
    );
  }
}