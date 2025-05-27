import 'package:intl/intl.dart';
import '../models/food_trace.dart';
import '../network/api_client.dart';
import '../utils/jwt_storage.dart';

class ImageProcessingService {
  static Future<List<FoodTrace>> getFoodTraces({DateTime? date}) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Formatted date: $formattedDate');
      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiClient.get(
        'food-trace/find?init=$formattedDate&end=$formattedDate',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 200 && responseData['data'] != null) {
          final List<dynamic> foodTracesList = responseData['data'];
          print('foodTracesList: $foodTracesList');
          return foodTracesList.map((item) => FoodTrace.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching food traces: $e');
      return [];
    }
  }

  static Future<FoodData?> processImage(String base64Image) async {
    final token = await JwtStorage.getToken();
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    print('image: $base64Image');
    try {
      final response = await ApiClient.post(
        'food-trace/process-image?id=1&tmp=0.2',
        // 'food-trace/process-image?id=1&tmp=0.5
        {'image': base64Image},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      print('response: $response');
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        print('responseData: $responseData');
        
        if (responseData['status'] == 200 && responseData['data'] != null) {
          final foodData = FoodData.fromJson(responseData['data']);
          foodData.base64Image = base64Image;
          return foodData;
        }
      }
      
      return null;
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  static Future<bool> saveFoodData(FoodData foodData, {DateTime? date}) async {
    try {

      final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      print('Formatted date: $formattedDate');

      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      final response = await ApiClient.post(
        'food-trace/save?date=$formattedDate',
        {
          'macrosData': foodData.toJson(),
          'image': foodData.base64Image,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('response: $response');
      return response.statusCode == 200;
    } catch (e) {
      print('Error saving food data: $e');
      return false;
    }
  }
}