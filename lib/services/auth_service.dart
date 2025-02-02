import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nutria/services/storage_service.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1'));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/authenticate', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Login failed', 'data': null};
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });
      if (response.data['code'] == 200) {
        await StorageService().saveToken(response.data['data']);
        return response.data;
      }
      return response.data;
    } catch (e) {
      return {'code': 500, 'message': 'Signin failed', 'data': null};
    }
  }
}
