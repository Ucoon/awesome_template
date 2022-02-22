///请求异常类
class HttpException implements Exception {
  final String? _message;
  final int? _code;
  HttpException([this._message, this._code]);

  String get message => _message ?? runtimeType.toString();

  int get code => _code ?? -1;

  @override
  String toString() {
    return "code:$code--message=$message";
  }
}

/// 客户端请求错误
class BadRequestException extends HttpException {
  BadRequestException({String? message, int? code}) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends HttpException {
  BadServiceException({String? message, int? code}) : super(message, code);
}

///未知错误
class UnknownException extends HttpException {
  UnknownException([String? message]) : super(message);
}

///请求取消错误
class CancelException extends HttpException {
  CancelException([String? message]) : super(message);
}

///网络异常错误
class NetworkException extends HttpException {
  NetworkException({String? message, int? code}) : super(message, code);
}

/// token失效错误
class UnauthorisedException extends HttpException {
  UnauthorisedException({String? message, int? code = 401}) : super(message);
}

///服务端返回报文错误
class BadResponseException extends HttpException {
  dynamic data;
  BadResponseException([this.data]) : super();
}
