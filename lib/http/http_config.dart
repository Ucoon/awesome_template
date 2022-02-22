import 'package:dio/dio.dart';

///dio 配置项
class HttpConfig {
  final String baseUrl;
  final String? proxy;
  final String? cookiesPath;
  final List<Interceptor>? interceptors;
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;
  final Map<String, dynamic>? headers;

  HttpConfig({
    required this.baseUrl,
    this.proxy,
    this.cookiesPath,
    this.interceptors,
    this.headers,
    this.connectTimeout = Duration.millisecondsPerMinute,
    this.sendTimeout = Duration.millisecondsPerMinute,
    this.receiveTimeout = Duration.millisecondsPerMinute,
  });
}
