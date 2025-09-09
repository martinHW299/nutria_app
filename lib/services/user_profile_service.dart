// lib/services/user_profile_service.dart
import '../network/api_client.dart';
import '../utils/jwt_storage.dart';
import '../models/user_profile.dart';

class UserProfileService {
  /// Get current user profile
  static Future<UserProfile?> getUserProfile() async {
    try {
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiClient.get(
        'auth/get-profile',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 200 && responseData['data'] != null) {
          return UserProfile.fromJson(responseData['data']);
        }
      }

      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Update user profile
  static Future<bool> updateUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiClient.get(
        'user/profile',
        profileData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  /// Update specific fields like weight, activity level, etc.
  static Future<bool> updateUserMetrics({
    double? weight,
    double? weightGoal,
    String? activityLevel,
    String? caloricAdjustment,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (weight != null) updates['weight'] = weight;
      if (weightGoal != null) updates['weightGoal'] = weightGoal;
      if (activityLevel != null) updates['activityLevel'] = activityLevel;
      if (caloricAdjustment != null)
        updates['caloricAdjustment'] = caloricAdjustment;

      if (updates.isEmpty) return false;

      return await updateUserProfile(updates);
    } catch (e) {
      print('Error updating user metrics: $e');
      return false;
    }
  }
}
