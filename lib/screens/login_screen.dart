import 'package:flutter/material.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/widgets/custom_text_field.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CustomTextField(
            controller: emailController,
            hintText: 'Email',
            // icon: Icons.email,
          ),
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            isObscure: true,
            // icon: Icons.lock,
          ),
          const SizedBox(height: 20),
          authProvider.isLoading
              ? CircularProgressIndicator()
              : PrimaryButton(
                  text: "Login",
                  onPressed: () => authProvider.login(
                      context, emailController.text, passwordController.text),
                ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: const Text("Don't have an account? Sign Up"),
          )
        ])),
      ),
    );
  }
}
