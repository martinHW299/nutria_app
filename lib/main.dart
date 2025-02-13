import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/providers/user_profile_provider.dart';
import 'package:nutria/screens/login_screen.dart';
import 'package:nutria/screens/main_screen.dart';
import 'package:nutria/screens/signup_scree.dart';
import 'package:nutria/screens/user_profile_intro_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Auth',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/userProfileIntro': (context) => UserProfileIntroScreen(),
          '/main': (context) => MainScreen(),
        },
      ),
    );
  }
}
