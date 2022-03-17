import 'package:flutter/services.dart';

///应用退出工具类
class ApplicationUtil {
  static DateTime? _lastPopTime;

  ///双击退出应用
  ///[second] 秒数
  ///[toastFunc] 提示弹窗, eg: "再次点击退出应用"
  static Future<bool> confirmExitApplication(int second,
      [Function? toastFunc]) {
    if (_lastPopTime == null ||
        DateTime.now().difference(_lastPopTime ?? DateTime.now()) >
            Duration(seconds: second)) {
      _lastPopTime = DateTime.now();
      if (toastFunc != null) toastFunc();
      return Future.value(true);
    }
    return Future.value(false);
  }

  ///直接退出应用
  static void exitApplication() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
