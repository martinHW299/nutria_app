import 'package:flutter/material.dart';
import 'package:nutria/screens/home_screen.dart';
import 'package:nutria/screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  ApiClient.initialize();
  
  // Check if user is already logged in
  final token = await AuthService.getToken();
  final isValid = token != null ? await AuthService.validateToken(token) : false;

  // Pass the isLoggedIn parameter to MyApp
  runApp(MyApp(isLoggedIn: isValid));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF066FFF),
          background: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF066FFF)),
          bodyMedium: TextStyle(color: Color(0xFF066FFF)),
          bodySmall: TextStyle(color: Color(0xFF066FFF)),
          headlineLarge: TextStyle(color: Color(0xFF066FFF)),
          headlineMedium: TextStyle(color: Color(0xFF066FFF)),
          headlineSmall: TextStyle(color: Color(0xFF066FFF)),
          titleLarge: TextStyle(color: Color(0xFF066FFF)),
          titleMedium: TextStyle(color: Color(0xFF066FFF)),
          titleSmall: TextStyle(color: Color(0xFF066FFF)),
          labelLarge: TextStyle(color: Color(0xFF066FFF)),
          labelMedium: TextStyle(color: Color(0xFF066FFF)),
          labelSmall: TextStyle(color: Color(0xFF066FFF)),
        ),
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}