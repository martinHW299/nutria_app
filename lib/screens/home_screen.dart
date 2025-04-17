import 'package:flutter/material.dart';
import 'package:nutria/screens/analytics_screen.dart';
import 'package:nutria/screens/trace_screen.dart';
import 'package:nutria/widgets/home/date_selector.dart';
import 'package:nutria/widgets/home/food_scanner_button.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  
  // Method to handle navigation changes
  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  
  // Method to handle date changes
  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }
  
  // Handle logout
  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Build the current screen based on the navigation index
    Widget currentScreen;
    switch (_currentIndex) {
      case 0:
        currentScreen = TraceScreen(selectedDate: _selectedDate);
        break;
      case 1:
        currentScreen = AnalyticsScreen(selectedDate: _selectedDate);
        break;
      default:
        currentScreen = TraceScreen(selectedDate: _selectedDate);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutria'),
        actions: [
          // Using the extracted date selector widget
          DateSelector(
            selectedDate: _selectedDate,
            onDateChanged: _onDateChanged,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: currentScreen,
      floatingActionButton: _currentIndex == 0
      ? FoodScannerButton(
          date: _selectedDate,
        )
      : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Food Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}