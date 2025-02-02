import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool readOnly;
  final Color borderColor; // Border color when not focused
  final Color textColor; // Text color
  final Color focusBorderColor; // Focused border color
  final Color focusLabelColor; // Focused label color
  final Color cursorColor; // Color of the cursor when typing

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.readOnly = false,
    this.borderColor = Colors.grey,
    this.textColor = Colors.grey,
    this.focusBorderColor = Colors.grey,
    this.focusLabelColor = Colors.grey,
    this.cursorColor = Colors.blue, // Default cursor color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        style: TextStyle(color: textColor), // Set the text color
        cursorColor: cursorColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor), // Set the border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: focusBorderColor), // Focus border color
          ),
          labelText: label,
          labelStyle: TextStyle(color: borderColor), // Default label color
          focusColor: focusLabelColor, // Focused label color
        ),
      ),
    );
  }
}
