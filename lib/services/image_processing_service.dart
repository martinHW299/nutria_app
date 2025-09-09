import 'package:intl/intl.dart';
import '../models/food_trace.dart';
import '../network/api_client.dart';
import '../utils/jwt_storage.dart';

class ImageProcessingService {
  static Future<List<FoodTrace>> getFoodTraces({DateTime? date}) async {
    try {
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(date ?? DateTime.now());
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
          return foodTracesList
              .map((item) => FoodTrace.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching food traces: $e');
      return [];
    }
  }

  static Future<FoodData?> processImage(
    String base64Image, {
    double? userServingSize,
  }) async {
    final token = await JwtStorage.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    print('Processing image with serving size: $userServingSize');

    try {
      // Prepare request body based on whether serving size is provided
      Map<String, dynamic> requestBody = {
        'image': base64Image,
        'useMockData': false,
        'temperature': 0.1,
      };

      // Add userServingSize only if provided
      if (userServingSize != null && userServingSize > 0) {
        requestBody['userServingSize'] = userServingSize;
      }

      print('Request body: $requestBody');

      final response = await ApiClient.post(
        'food-trace/analyze-food',
        requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Analyze food response: $response');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Response data: $responseData');

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
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(date ?? DateTime.now());
      print('Formatted date: $formattedDate');

      final token = await JwtStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiClient.post(
        'food-trace/save?date=$formattedDate',
        {'macrosData': foodData.toJson(), 'image': foodData.base64Image},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Save food response: $response');
      return response.statusCode == 200;
    } catch (e) {
      print('Error saving food data: $e');
      return false;
    }
  }
}
