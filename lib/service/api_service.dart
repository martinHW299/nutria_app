import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String baseUrl = "http://localhost:8080/api/v1";

  /// Login request for new users.
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/register', data: {
        'email': email,
        'password': password,
      });
      print(response);
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Login failed', 'data': null};
    }
  }

  /// Signin request for existing users to get JWT token.
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/authenticate', data: {
        'email': email,
        'password': password,
      });
      print(response);
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Signin failed', 'data': null};
    }
  }

  /// Save the JWT token securely.
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  /// Retrieve the JWT token securely.
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Logout and clear the token.
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
