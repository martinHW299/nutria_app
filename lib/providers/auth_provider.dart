// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nutria/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    setLoading(true);
    final result = await _authService.login(email, password);
    setLoading(false);
    if (result['code'] == 200) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> signup(BuildContext context, String email, String password,
      String confirmPassword) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red),
      );
      return;
    }
    setLoading(true);
    final result = await _authService.signup(email, password);
    setLoading(false);
    if (result['code'] == 200) {
      final result = await _authService.login(email, password);
      if (result['code'] == 200) {
        Navigator.pushReplacementNamed(context, '/userProfileIntro');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }
}
