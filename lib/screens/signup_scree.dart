import 'package:flutter/material.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/widgets/input_field.dart';
import 'package:nutria/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            InputField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            InputField(
              controller: passwordController,
              label: 'Password',
              isObscure: true,
              icon: Icons.lock,
            ),
            authProvider.isLoading
                ? CircularProgressIndicator()
                : PrimaryButton(
                    onPressed: () => authProvider.signup(
                      context,
                      emailController.text,
                      passwordController.text,
                    ),
                    text: 'Sign up',
                  ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
