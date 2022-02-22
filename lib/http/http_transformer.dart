import 'package:dio/dio.dart';
import 'http_response.dart';

///Response解析
abstract class HttpTransformer {
  HttpResponse parse(Response response);
  int succeedCode();
}

class DefaultHttpTransformer extends HttpTransformer {
  // 假设接口返回类型
  //   {
  //     "code": 2000,
  //     "data": {},
  //     "message": "success"
  // }
  @override
  HttpResponse parse(Response response) {
    if (response.data['code'] == succeedCode()) {
      return HttpResponse.success(response.data['data']);
    } else {
      return HttpResponse.failure(
          errorMsg: response.data['message'], errorCode: response.data['code']);
    }
  }

  @override
  int succeedCode() {
    return 20000;
  }

  ///单例对象
  static late final DefaultHttpTransformer _instance =
      DefaultHttpTransformer._internal();

  DefaultHttpTransformer._internal();

  factory DefaultHttpTransformer() => _instance;
}
