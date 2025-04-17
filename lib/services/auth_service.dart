import '../network/api_client.dart';
import '../utils/jwt_storage.dart';

class AuthService {
  static Future<dynamic> login(String email, String password) async {
    try {
      final res = await ApiClient.get('auth/login', {
        'email': email,
        'password': password,
      });
      
      if (res.statusCode == 200) {
        // Extract token from nested data structure
        final responseData = res.data;
        final data = responseData['data'];
        
        // The token is directly in the data field
        if (data != null && data is String) {
          await JwtStorage.saveToken(data);
          return true;
        }
      }
      return res.data['message'] ?? 'Signup failed';
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<dynamic> signup(Map<String, dynamic> userData) async {
    try {
      
      print('Sending signup data: $userData');
      final res = await ApiClient.post('auth/signup', userData, headers: {'Content-Type': 'application/json'});
      print('Signup response: $res');
      if (res.statusCode == 200) {
        final responseData = res.data;
        
        // Check if we have data in the response
        if (responseData['status'] == 200 && responseData['data'] != null) {
          responseData['data'];
          login(userData['email'], userData['password']);
          return true;
        }
      }
      print('Signup failed: ${res.statusCode} - ${res.data}');
      return res.data['message'] ?? 'Signup failed';
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getHealthAdvice(double height, double weight) async {
    try {
      print(height);
      print(weight);
      final response = await ApiClient.get(
        'auth/advisor',
        {
          'height': height,
          'weight': weight,
        },
        headers: {'Content-Type': 'application/json'},
      );
      
      print('response: $response');
      
      if (response.statusCode == 200) {
        // Access the data field directly since it's already a Map
        if (response.data is Map && response.data.containsKey('data')) {
          print('response.data: ${response.data['data']}');
          return response.data['data'];
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Health advice error: $e');
      return null;
    }
  }

  static Future<bool> validateToken(String? token) async {
    if (token == null) return false;
    
    try {
      final res = await ApiClient.post('auth/validate', null, headers: {
        'Authorization': 'Bearer $token',
      });
      
      // Assuming the validate endpoint returns a similar response structure
      return res.statusCode == 200;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  static Future<String?> getToken() => JwtStorage.getToken();
  
  static Future<void> logout() => JwtStorage.clearToken();
}