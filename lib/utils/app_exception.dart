class AppException implements Exception {
  // Constructor with dynamic params
  AppException([this._message, this._prefix]);
  final String? _message;
  final String? _prefix;

  String get message => _message ?? "";

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class ApiException extends AppException {
  final int code;
  final String message;
  ApiException(this.code) : message = 'Api error with code $code';

  ///
  /// Helper error checking
  ///

}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, 'Unauthorised: ');
}

class InvalidResponseException extends AppException {
  InvalidResponseException([String? message])
      : super(message, 'Invalid Response: ');
}
