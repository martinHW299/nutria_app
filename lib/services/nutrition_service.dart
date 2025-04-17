// lib/services/nutrition_service.dart
import 'package:intl/intl.dart';
import 'package:nutria/network/api_client.dart';
import 'package:nutria/utils/jwt_storage.dart';
import 'package:nutria/models/nutrition_goal.dart';
import 'package:nutria/models/daily_intake.dart';

class NutritionService {


  static Future<bool> setNutritionGoal({required DateTime date}) async {
    try {
      // Format the date
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Setting default nutrition goal for date: $formattedDate');
      
      // Get token
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Make the API request
      final response = await ApiClient.post(
        'nutrition-trace/save-goal?date=$formattedDate',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error setting default nutrition goal: $e');
      return false;
    }
  }


  static Future<NutritionGoal?> getNutritionGoal({DateTime? date}) async {
    try {
      // Format the date or use today
      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Getting nutrition goal for date: $formattedDate');
      
      // Get token
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Make the API request
      final response = await ApiClient.get(
        'nutrition-trace/get-goal?date=$formattedDate',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Check if we have data
        if (responseData['status'] == 200 && responseData['data'] != null) {
          return NutritionGoal.fromJson(responseData['data']);
        }
      }
      
      // Return null if no data or error
      return null;
    } catch (e) {
      print('Error fetching nutrition goal: $e');
      return null;
    }
  }

  static Future<DailyIntake?> getDailyIntake({DateTime? date}) async {
    try {
      // Format the date or use today
      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Getting daily intake for date: $formattedDate');
      
      // Get token
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Make the API request
      final response = await ApiClient.get(
        'nutrition-trace/get-daily-intake?date=$formattedDate',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Check if we have data
        if (responseData['status'] == 200 && responseData['data'] != null) {
          return DailyIntake.fromJson(responseData['data']);
        }
      }
      
      // Return null if no data or error
      return null;
    } catch (e) {
      print('Error fetching daily intake: $e');
      return null;
    }
  }

    static Future<bool> deleteFoodRecord({required int id}) async {
    try {
      // Get token
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Make the API request
      final response = await ApiClient.post(
        'food-trace/delete?intake=$id',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error setting default nutrition goal: $e');
      return false;
    }
  }
}