import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    ///error统一处理
    debugPrint(
        'ErrorInterceptor.onError ${err.requestOptions.baseUrl}${err.requestOptions.path}'
        ' ${err.response?.statusCode} ${err.error}');
    int code = 0;
    String message = '';
    if (err.response != null) {
      debugPrint('ErrorInterceptor.onError response ${err.response?.data}');
      code = err.response?.statusCode ?? 0;
    }

    if (code == 500 ||
        err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.receiveTimeout) {
      debugPrint('ErrorInterceptor.onError 网络好像出了点问题');
    }

    if (code == 400) {
      if (err.response?.data is Map) {
        message = err.response?.data['errors'] ??
            err.response?.data['message'] ??
            message;
      }
      debugPrint('ErrorInterceptor.onError $message');
    }

    if (code == 401) {
      debugPrint('ErrorInterceptor.onError 暂无权限');
    }
    return handler.reject(err);
  }
}
