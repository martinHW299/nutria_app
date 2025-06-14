// lib/network/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.229:8080/api/v1/',
    contentType: 'application/json',
    responseType: ResponseType.json,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  // Initialize Dio with interceptors for logging
  static void initialize() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Method for GET requests
  static Future<Response> get(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('DioException: ${e.message}');
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Method for POST requests
  static Future<Response> post(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('DioException: ${e.message}');
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}