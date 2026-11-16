import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message});
}

Failure mapExceptionToFailure(Object error) {
  if (error is UnauthorizedException) {
    return UnauthorizedFailure(message: error.message);
  }
  if (error is ValidationException) {
    return ValidationFailure(message: error.message);
  }
  if (error is NetworkException) {
    return NetworkFailure(message: error.message);
  }
  if (error is CacheException) {
    return CacheFailure(message: error.message);
  }
  if (error is ServerException) {
    return ServerFailure(message: error.message);
  }
  return ServerFailure(message: error.toString());
}
