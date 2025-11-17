import '../network/api_client.dart';
import '../utils/jwt_storage.dart';

class AuthService {
  static Future<dynamic> login(String email, String password) async {
    print('🌐 AuthService.login CALLED');
    print('🌐 Time: ${DateTime.now()}');
    print('🌐 Email: $email');
    try {
      print('🌐 Making API call to auth/login...');
      final res = await ApiClient.post('auth/login', {
        'email': email,
        'password': password,
      });
      print('🌐 Response received - Status: ${res.statusCode}');

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
      return res.data['message'] ?? 'Login failed';
    } catch (e) {
      // print('Login error: $e');
      return false;
    }
  }

  static Future<dynamic> signup(Map<String, dynamic> userData) async {
    try {
      // Validate required fields before sending
      final requiredFields = [
        'name',
        'lastName',
        'email',
        'password',
        'age',
        'gender',
        'height',
        'weight',
        'weightGoal',
        'activityLevel',
        'caloricAdjustment',
      ];

      for (String field in requiredFields) {
        if (!userData.containsKey(field) || userData[field] == null) {
          // print('Missing required field: $field');
          return 'Faltan datos requeridos: $field';
        }
      }

      // Ensure numeric fields are properly typed
      final processedData = {
        'name': userData['name'].toString().trim(),
        'lastName': userData['lastName'].toString().trim(),
        'email': userData['email'].toString().trim(),
        'password': userData['password'].toString(),
        'age':
            userData['age'] is int
                ? userData['age']
                : int.tryParse(userData['age'].toString()) ?? 0,
        'gender': userData['gender'].toString(),
        'height':
            userData['height'] is double
                ? userData['height']
                : double.tryParse(userData['height'].toString()) ?? 0.0,
        'weight':
            userData['weight'] is double
                ? userData['weight']
                : double.tryParse(userData['weight'].toString()) ?? 0.0,
        'weightGoal':
            userData['weightGoal'] is double
                ? userData['weightGoal']
                : double.tryParse(userData['weightGoal'].toString()) ?? 0.0,
        'activityLevel': userData['activityLevel'].toString(),
        'caloricAdjustment': userData['caloricAdjustment'].toString(),
      };

      // print('Sending signup data: $processedData');

      final res = await ApiClient.post(
        'auth/signup',
        processedData,
        headers: {'Content-Type': 'application/json'},
      );

      // print('Signup response: ${res.statusCode} - ${res.data}');

      if (res.statusCode == 200) {
        final responseData = res.data;

        // Check if we have data in the response
        if (responseData['status'] == 200 && responseData['data'] != null) {
          // Auto-login after successful signup
          // print('Signup successful, attempting auto-login...');
          final loginResult = await login(
            processedData['email'],
            processedData['password'],
          );
          return loginResult;
        } else {
          // print('Signup failed - invalid response structure');
          return responseData['message'] ?? 'Error en el registro';
        }
      } else {
        // print('Signup failed with status: ${res.statusCode}');
        return res.data['message'] ?? 'Error en el registro';
      }
    } catch (e) {
      // print('Signup error: $e');
      return 'Error de conexión durante el registro';
    }
  }

  static Future<Map<String, dynamic>?> getHealthAdvice(
    double height,
    double weight,
  ) async {
    try {
      // print('Getting health advice for height: $height, weight: $weight');
      final response = await ApiClient.get(
        'auth/advisor',
        {'height': height, 'weight': weight},
        headers: {'Content-Type': 'application/json'},
      );

      // print(
      //   'Health advice response: ${response.statusCode} - ${response.data}',
      // );

      if (response.statusCode == 200) {
        // Access the data field directly since it's already a Map
        if (response.data is Map && response.data.containsKey('data')) {
          // print('Health advice data: ${response.data['data']}');
          return response.data['data'];
        }
        return null;
      } else {
        // print('Health advice failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Health advice error: $e');
      return null;
    }
  }

  static Future<bool> validateToken(String? token) async {
    if (token == null) return false;

    try {
      final res = await ApiClient.post(
        'auth/validate',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );

      return res.statusCode == 200;
    } catch (e) {
      // print('Token validation error: $e');
      return false;
    }
  }

  static Future<String?> getToken() => JwtStorage.getToken();

  static Future<void> logout() => JwtStorage.clearToken();
}
