import 'package:dio/dio.dart';
import 'package:nutria/services/storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1/auth'));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/authenticate', data: {
        'email': email,
        'password': password,
      });
      if (response.data['code'] == 200) {
        await _storage.saveToken(response.data['data']);
      }
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Login failed', 'data': null};
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Signin failed', 'data': null};
    }
  }
}
