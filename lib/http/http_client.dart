import 'app_dio.dart';

class HttpClient {
  late AppDio _dio;

  HttpClient._internal();
  static late final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;

}
