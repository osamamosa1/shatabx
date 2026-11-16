class AppException implements Exception {
  const AppException({this.message});

  final String? message;

  @override
  String toString() => message ?? 'AppException';
}

class ServerException extends AppException {
  const ServerException({super.message});
}

class CacheException extends AppException {
  const CacheException({super.message});
}

class NetworkException extends AppException {
  const NetworkException({super.message});
}

class ValidationException extends AppException {
  const ValidationException({super.message});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message});
}
