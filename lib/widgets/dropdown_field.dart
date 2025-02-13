import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final List<Map<String, String>> items;
  final Function(String) onChanged;

  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      value: selectedValue,
      items: widget.items
          .map((item) => DropdownMenuItem(
                value: item['value'],
                child: Text(item['label']!),
              ))
          .toList(),
      onChanged: (newValue) {
        setState(() => selectedValue = newValue);
        widget.onChanged(newValue!);
      },
    );
  }
}
