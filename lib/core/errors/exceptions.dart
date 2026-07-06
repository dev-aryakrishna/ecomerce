class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class UnknownException implements Exception {
  final String message;

  UnknownException(this.message);
}

/// Thrown when user-provided input fails local validation rules
/// before any network/repository call is made.
class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}