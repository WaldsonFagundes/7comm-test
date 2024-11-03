class UnauthorizedException implements Exception {
  final String? message;

  UnauthorizedException({this.message});

  @override
  String toString() {
    return "Unauthorized: $message";
  }
}

class SecretNotFoundException implements Exception {}

class UserNotFoundException implements Exception {}

class UnknownErrorException implements Exception {}
