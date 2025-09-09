// lib/utils/error_handler.dart
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    return 'Ha ocurrido un error inesperado';
  }

  static void logError(String service, String method, dynamic error) {
    print('[$service.$method] Error: $error');
  }
}
