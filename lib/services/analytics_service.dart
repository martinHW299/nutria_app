import 'package:intl/intl.dart';
import 'package:nutria/models/food_trace.dart';
import 'package:nutria/models/nutrition_data.dart';
import 'package:nutria/network/api_client.dart';
import 'package:nutria/utils/jwt_storage.dart';

class AnalyticsService {
  /// Fetches food traces for a specific date
  static Future<List<FoodTrace>> getFoodTraces({required DateTime date}) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Formatted date: $formattedDate');

      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final res = await ApiClient.get(
        'nutrition-trace/get-daily-intake?date=$formattedDate', 
        null, 
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (res.statusCode == 200 && res.data['status'] == 200) {
        final List<dynamic> tracesData = res.data['data'] ?? [];
        return tracesData.map((data) => FoodTrace.fromJson(data)).toList();
      }
      
      print('Failed to get food traces: ${res.statusCode} - ${res.data}');
      return [];
    } catch (e) {
      print('Error fetching food traces: $e');
      return [];
    }
  }

  /// Fetches weekly nutrition data
  static Future<List<NutritionData>> getWeeklyIntake({required DateTime date}) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Formatted date: $formattedDate');

      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final res = await ApiClient.get(
        'nutrition-trace/get-weekly-intake?date=$formattedDate',
        null, 
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (res.statusCode == 200 && res.data['status'] == 200) {
        final List<dynamic> weekData = res.data['data'] ?? [];
        return weekData.map<NutritionData>((data) => NutritionData.fromJson(data)).toList();
      }
      
      print('Failed to get weekly intake data: ${res.statusCode} - ${res.data}');
      return [];
    } catch (e) {
      print('Error fetching weekly intake data: $e');
      return [];
    }
  }

  /// Fetches monthly nutrition data
  static Future<List<NutritionData>> getMonthlyIntake({required DateTime date}) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Formatted date: $formattedDate');

      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final res = await ApiClient.get(
        'nutrition-trace/get-monthly-intake?date=$formattedDate',
        null, 
        headers: {'Authorization': 'Bearer $token'},
      );

      print('res: $res');
      
      if (res.statusCode == 200 && res.data['status'] == 200) {
        final List<dynamic> monthData = res.data['data'] ?? [];
        print('monthData: $monthData');
        return monthData.map<NutritionData>((data) => NutritionData.fromJson(data)).toList();
      }
      
      print('Failed to get monthly intake data: ${res.statusCode} - ${res.data}');
      return [];
    } catch (e) {
      print('Error fetching monthly intake data: $e');
      return [];
    }
  }
}