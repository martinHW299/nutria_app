import 'package:flutter/material.dart';
import 'package:nutria/utilities/app_colors.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.appBarColor,
            fontWeight: FontWeight.w500,
            fontSize: 30),
      ),
    );
  }
}
