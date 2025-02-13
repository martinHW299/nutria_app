import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  // final IconData icon;
  final bool isObscure;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscuredText = true;

  @override
  void initState() {
    super.initState();
    _obscuredText = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isObscure ? _obscuredText : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          hintText: widget.hintText,
          // prefixIcon: Icon(widget.icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          suffixIcon: widget.isObscure
              ? IconButton(
                  icon: Icon(
                    _obscuredText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscuredText = !_obscuredText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
