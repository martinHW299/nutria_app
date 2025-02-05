import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isObscure;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE7EDEB),
        hintText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
