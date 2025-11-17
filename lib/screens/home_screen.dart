import 'package:flutter/material.dart';
import 'package:nutria/screens/analytics_screen.dart';
import 'package:nutria/screens/trace_screen.dart';
import 'package:nutria/widgets/home/date_selector.dart';
import 'package:nutria/widgets/home/food_scanner_button.dart';
import 'package:nutria/widgets/sidebar_drawer.dart';
import 'package:nutria/widgets/loading_overlay.dart';
// import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String _loadingMessage = '';

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
  // Future<void> _handleLogout() async {
  //   await AuthService.logout();
  //   if (mounted) {
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  // Loading overlay methods
  void _showLoading(String message) {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingMessage = message;
      });
    }
  }

  void _hideLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Nutria'),
            actions: [
              // Using the extracted date selector widget
              DateSelector(
                selectedDate: _selectedDate,
                onDateChanged: _onDateChanged,
              ),
              // IconButton(
              //   icon: const Icon(Icons.logout),
              //   onPressed: _handleLogout,
              //   tooltip: 'Cerrar sesión',
              // ),
            ],
          ),
          drawer: const SidebarDrawer(),
          body: currentScreen,
          floatingActionButton:
              _currentIndex == 0
                  ? FoodScannerButton(
                    date: _selectedDate,
                    onShowLoading: _showLoading,
                    onHideLoading: _hideLoading,
                  )
                  : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onNavigationChanged,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank),
                label: 'Diario',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_sharp),
                label: 'Análisis',
              ),
            ],
          ),
        ),
        // Loading overlay
        LoadingOverlay(message: _loadingMessage, isVisible: _isLoading),
      ],
    );
  }
}
