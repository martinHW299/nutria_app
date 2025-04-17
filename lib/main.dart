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
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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