import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'http_config.dart';

class AppDio with DioMixin implements Dio {
  AppDio({BaseOptions? options, HttpConfig? dioConfig}) {
    options ??= BaseOptions(
      baseUrl: dioConfig?.baseUrl ?? '',
      contentType: ContentType.json.value,
      connectTimeout: dioConfig?.connectTimeout,
      sendTimeout: dioConfig?.sendTimeout,
      receiveTimeout: dioConfig?.receiveTimeout,
    )..headers = dioConfig?.headers;
    this.options = options;

    /// DioCacheManager
    final cacheOptions = CacheOptions(
      // a default store is required for interceptor.
      store: MemCacheStore(),
      //Optional. Returns a cached response on error but for statuses 401 && 403
      hitCacheOnErrorExcept: [401, 403],
      //Optional. Overrides any HTTP directive to delete entry past this duration
      maxStale: const Duration(days: 7),
    );
    interceptors.add(DioCacheInterceptor(options: cacheOptions));

    ///Cookie管理
    if (dioConfig?.cookiesPath?.isNotEmpty ?? false) {
      interceptors.add(CookieManager(
          PersistCookieJar(storage: FileStorage(dioConfig!.cookiesPath))));
    }
    if (kDebugMode) {
      interceptors.add(LogInterceptor(
        error: true,
        responseBody: true,
        requestBody: true,
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    }
    if (dioConfig?.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(dioConfig!.interceptors!);
    }
    httpClientAdapter = DefaultHttpClientAdapter();
    if (dioConfig?.proxy?.isNotEmpty ?? false) {
      setProxy(dioConfig!.proxy!);
    }
  }

  setProxy(String proxy) {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return 'PROXY $proxy';
      };
      return client; // you can also create a HttpClient to dio
    };
  }
}
