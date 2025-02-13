import 'package:dio/dio.dart';

class UserProfileService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1/profile'));

  Future<Map<String, dynamic>> saveUserProfile(
      String? token, Map<String, dynamic> userProfile) async {
    try {
      final response = await _dio.post('/save',
          data: userProfile,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      return response.data;
    } catch (e) {
      return {
        'code': 500,
        'message': 'Profile submission failed',
        'data': null
      };
    }
  }
}
