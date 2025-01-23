// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nutria_app/service/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;

  String? get token => _token;


  Future<bool> authenticateUser(
      BuildContext context, String email, String password) async {
    try {
      // Attempt login
      final loginResponse = await _apiService.login(email, password);

      if (loginResponse['code'] == 200) {
        // Login successful, proceed to signin
        final signinResponse = await _apiService.signIn(email, password);

        if (signinResponse['code'] == 200) {
          // Signin successful, save token and update state
          _token = signinResponse['data'];
          await _apiService.saveToken(_token!);
          notifyListeners();
          return true;
        } else {
          // Handle signin failure
          _showPopup(context, 'Signin Error', signinResponse['message']);
          return false;
        }
      } else {
        // Handle login failure
        _showPopup(context, 'Login Error', loginResponse['message']);
        return false;
      }
    } catch (e) {
      _showPopup(context, 'Error', 'An unexpected error occurred.');
      return false;
    }
  }

  /// Logout the user and clear token.
  Future<void> logout() async {
    await _apiService.logout();
    _token = null;
    notifyListeners();
  }

  /// Show a popup for success or error messages.
  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void setToken(String token) {
    _token = token;
    Future.microtask(() => notifyListeners());
  }
}
