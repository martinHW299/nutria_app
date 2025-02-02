import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color color;
  const TitleWidget({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 30),
      ),
    );
  }
}
