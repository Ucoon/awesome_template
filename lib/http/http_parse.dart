import 'dart:io';
import 'package:dio/dio.dart';
import 'http_exceptions.dart';
import 'http_response.dart';
import 'http_transformer.dart';

HttpResponse handleResponse(Response? response,
    {HttpTransformer? httpTransformer}) {
  ///返回值异常
  if (response == null) {
    return HttpResponse.failureFromResponse();
  }
  httpTransformer ??= DefaultHttpTransformer();
  print('handleResponse ${_isTokenTimeout(response.statusCode)}');
  if (_isTokenTimeout(response.statusCode)) {
    return HttpResponse.failureFromError(UnauthorisedException(
      message: '没有权限',
      code: response.statusCode,
    ));
  }

  if (_isRequestSuccess(response.statusCode)) {
    return httpTransformer.parse(response);
  } else {
    return HttpResponse.failure(
        errorMsg: response.statusMessage, errorCode: response.statusCode);
  }
}

///token失效
bool _isTokenTimeout(int? statusCode) {
  return statusCode == 401;
}

///请求成功
bool _isRequestSuccess(int? statusCode) {
  return (statusCode != null && statusCode >= 200 && statusCode < 300);
}

HttpResponse handleException(Exception exception) {
  var parseException = _parseException(exception);
  return HttpResponse.failureFromError(parseException);
}

HttpException _parseException(Exception error) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return NetworkException(message: error.message);
      case DioErrorType.cancel:
        return CancelException(error.message);
      case DioErrorType.response:
        try {
          return BadResponseException(error.response?.data);
        } on Exception catch (_) {
          return UnknownException(error.message);
        }
      case DioErrorType.other:
        if (error.error is SocketException) {
          return NetworkException(message: error.message);
        } else {
          return UnknownException(error.message);
        }
      default:
        return UnknownException(error.message);
    }
  } else {
    return UnknownException(error.toString());
  }
}
