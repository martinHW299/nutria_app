import 'package:flutter/material.dart';
import 'package:nutria_app/provider/auth_provider.dart';
import 'package:nutria_app/screen/home.dart';
import 'package:nutria_app/screen/login.dart';
import 'package:nutria_app/service/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
      ),
    );
  }
}

/// A wrapper that determines the initial screen based on authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<String?>(
      future: ApiService().getToken(), // Check for stored JWT token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner
        }

        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          // If a valid token exists, set it in the provider and go to HomeScreen
          authProvider.setToken(snapshot.data!); // Set token in AuthProvider
          return HomeScreen();
        } else {
          // Otherwise, show the LoginScreen
          return LoginScreen();
        }
      },
    );
  }
}
