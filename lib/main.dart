import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nutria/screens/credential_screen.dart';
import 'package:nutria/screens/home_screen.dart';
import 'package:nutria/screens/onboarding_screen.dart';
import 'package:nutria/screens/profile_screen.dart';
import 'package:nutria/screens/signup_screen.dart';
import 'package:nutria/screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client
  ApiClient.initialize();

  // Initialize Spanish locale
  await initializeDateFormatting('es', null);

  // Check if user is already logged in
  final token = await AuthService.getToken();
  final isValid =
      token != null ? await AuthService.validateToken(token) : false;

  // Pass the isLoggedIn parameter to MyApp
  runApp(MyApp(isLoggedIn: isValid));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutrIA',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF066FFF),
          primary: const Color(0xFF066FFF),
          secondary: const Color(0xFF066FFF),
          background: Colors.white,
          surface: Colors.white,
        ),
        // textTheme: const TextTheme(
        //   bodyLarge: TextStyle(color: Color(0xFF066FFF)),
        //   bodyMedium: TextStyle(color: Color(0xFF066FFF)),
        //   bodySmall: TextStyle(color: Color(0xFF066FFF)),
        //   headlineLarge: TextStyle(color: Color(0xFF066FFF)),
        //   headlineMedium: TextStyle(color: Color(0xFF066FFF)),
        //   headlineSmall: TextStyle(color: Color(0xFF066FFF)),
        //   titleLarge: TextStyle(color: Color(0xFF066FFF)),
        //   titleMedium: TextStyle(color: Color(0xFF066FFF)),
        //   titleSmall: TextStyle(color: Color(0xFF066FFF)),
        //   labelLarge: TextStyle(color: Color(0xFF066FFF)),
        //   labelMedium: TextStyle(color: Color(0xFF066FFF)),
        //   labelSmall: TextStyle(color: Color(0xFF066FFF)),
        // ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF066FFF),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF066FFF), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/credentials': (context) => const CredentialsScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
