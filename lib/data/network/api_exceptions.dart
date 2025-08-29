class AppException implements Exception {
  final String? _message;
  final int? code;

  AppException([this.code, this._message]);

  @override
  String toString() {
    return "$code$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([super.code, super.message]);
}

class BadRequestException extends AppException {
  BadRequestException([int? code, message]);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([super.code, super.message]);
}

class NotFoundRequestException extends AppException {
  NotFoundRequestException([super.code, super.message]);
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([super.code, super.message]);
}

class InvalidInputException extends AppException {
  InvalidInputException([super.code, super.message]);
}

class AuthenticationException extends AppException {
  AuthenticationException([super.code, super.message]);
}

class UnprocessableContent extends AppException {
  UnprocessableContent([super.code, super.message]);
}

class SocketConnectionError extends AppException {
  SocketConnectionError([super.code, super.message]);
}

class ServerException extends AppException {
  ServerException([super.code, super.message]);
}
