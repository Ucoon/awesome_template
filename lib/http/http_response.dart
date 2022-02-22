import 'http_exceptions.dart';

class HttpResponse {
  late bool isSuccessful;
  dynamic data;
  HttpException? error;

  HttpResponse._internal({this.isSuccessful = false});

  HttpResponse.success(this.data) {
    isSuccessful = true;
  }

  HttpResponse.failure({String? errorMsg, int? errorCode}) {
    error = BadRequestException(message: errorMsg, code: errorCode);
    isSuccessful = false;
  }

  HttpResponse.failureFromResponse({dynamic data}) {
    error = BadResponseException(data);
    isSuccessful = false;
  }

  HttpResponse.failureFromError([HttpException? error]) {
    this.error = error ?? UnknownException();
    isSuccessful = false;
  }
}
