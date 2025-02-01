import 'package:flutter/material.dart';
import 'package:nutria/screens/analytic_screen.dart';
import 'package:nutria/screens/food_screen.dart';
import 'package:nutria/screens/home_screen.dart';
import 'package:nutria/utilities/app_colors.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: "Food",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_saver_off_outlined),
            label: "Analytic",
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}
