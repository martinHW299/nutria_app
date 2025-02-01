import 'package:flutter/material.dart';
import 'package:nutria/screens/analytic_screen.dart';
import 'package:nutria/screens/food_screen.dart';
import 'package:nutria/screens/home_screen.dart';
import 'package:nutria/utilities/app_colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    const HomeScreen(),
    const FoodScreen(),
    const AnalyticScreen(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        color: AppColors.appBarColor,
        index: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.food_bank,
            color: Colors.white,
          ),
          Icon(
            Icons.data_saver_off_outlined,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
