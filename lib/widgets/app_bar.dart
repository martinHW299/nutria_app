import 'package:flutter/material.dart';
import 'package:nutria/utilities/app_colors.dart';

Widget appBar(String title) {
  return AppBar(
    backgroundColor: AppColors.appBarColor,
    title: Text(title),
  );
}

