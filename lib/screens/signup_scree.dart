import 'package:flutter/material.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/utilities/app_colors.dart';
import 'package:nutria/widgets/input_field_widget.dart';
import 'package:nutria/widgets/title_widget.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TitleWidget(
              title: 'Sign up',
              color: AppColors.appBarColor,
            ),
            InputField(
              controller: emailController,
              label: 'User Name',
            ),
            InputField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => authProvider.signup(
                      context,
                      emailController.text,
                      passwordController.text,
                    ),
                    child: Text('Sign Up'),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context), // Return to Login Screen
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
