class AuthException implements Exception {
  final String exception;

  AuthException(this.exception);

  @override
  String toString() => exception;
}