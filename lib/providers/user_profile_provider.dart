// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nutria/services/storage_service.dart';
import 'package:nutria/services/user_profile_service.dart';

class UserProfileProvider extends ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  final StorageService _storage = StorageService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> submitUserProfile(
      BuildContext context, Map<String, dynamic> userProfile) async {
    String? token = await _storage.getToken();
    setLoading(true);
    final result =
        await _userProfileService.saveUserProfile(token, userProfile);
    setLoading(false);
    if (result['code'] == 200) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }
}
