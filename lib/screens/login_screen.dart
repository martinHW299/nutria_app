import 'package:flutter/material.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/widgets/input_field.dart';
import 'package:nutria/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Log in')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            InputField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 10),
            InputField(
              controller: passwordController,
              label: 'Password',
              isObscure: true,
              icon: Icons.lock,
            ),
            const SizedBox(height: 20),
            authProvider.isLoading
                ? CircularProgressIndicator()
                : PrimaryButton(
                    text: "Login",
                    onPressed: () => authProvider.login(
                        context, emailController.text, passwordController.text),
                  ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don't have an account? Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
