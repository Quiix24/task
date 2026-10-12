abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({required this.statusCode, required String message})
    : super(message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}
