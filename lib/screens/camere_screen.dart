import 'package:flutter/material.dart';
import 'package:nutria/utilities/app_colors.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: const Center(
        child: Text("Camera"),
      ),
    );
  }
}
