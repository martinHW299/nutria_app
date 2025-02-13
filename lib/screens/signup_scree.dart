import 'package:flutter/material.dart';
import 'package:nutria/providers/auth_provider.dart';
import 'package:nutria/widgets/custom_text_field.dart';
import 'package:nutria/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const Text("Create an Account",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  CustomTextField(
                      hintText: "Email", controller: emailController),
                  CustomTextField(
                      hintText: "Password",
                      controller: passwordController,
                      isObscure: true),
                  CustomTextField(
                      hintText: "Confirm Password",
                      controller: confirmPasswordController,
                      isObscure: true),
                  const SizedBox(height: 20),
                  authProvider.isLoading
                      ? CircularProgressIndicator()
                      : PrimaryButton(
                          onPressed: () => authProvider.signup(
                            context,
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                          ),
                          text: 'Sign up',
                        ),
                  SizedBox(height: 10)
                ],
              )),
            )));
  }

  // @override
  // Widget build(BuildContext context) {
  //   final authProvider = Provider.of<AuthProvider>(context);
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Sign Up')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: ListView(
  //         children: <Widget>[
  //           CustomTextField(
  //             controller: emailController,
  //             label: 'Email',
  //             // icon: Icons.email,
  //           ),
  //           CustomTextField(
  //             controller: passwordController,
  //             label: 'Password',
  //             isObscure: true,
  //             // icon: Icons.lock,
  //           ),
  //           authProvider.isLoading
  //               ? CircularProgressIndicator()
  //               : PrimaryButton(
  //                   onPressed: () => authProvider.signup(
  //                     context,
  //                     emailController.text,
  //                     passwordController.text,
  //                   ),
  //                   text: 'Sign up',
  //                 ),
  //           SizedBox(height: 10)
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
