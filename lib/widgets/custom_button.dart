import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? Color(0xFF2E86C1) : Colors.white,
            foregroundColor: isPrimary ? Colors.white : Color(0xFF2E86C1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: isPrimary
                  ? BorderSide.none
                  : const BorderSide(color: Color(0xFF2E86C1)),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
