import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutria_app/screen/home.dart';
import 'package:nutria_app/screen/login.dart';
import 'package:nutria_app/service/api_service.dart';
import 'package:nutria_app/utils/global.colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check token to decide next screen
    final token = await ApiService().getToken();
    if (token != null && token.isNotEmpty) {
      // Set token in AuthProvider if not null
      Get.off(() => HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    } else {
      // Navigate to login if no token
      Get.off(() => LoginScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: const Center(
        child: Text("NUTRIA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
