abstract final class ApiConstants {
  static const String host = 'https://back2.moon-designs.net/public';
  static const String baseUrl = '$host/api';

  static const Duration connectTimeout = Duration(seconds: 25);
  static const Duration receiveTimeout = Duration(seconds: 25);
  static const Duration sendTimeout = Duration(seconds: 45);
}
