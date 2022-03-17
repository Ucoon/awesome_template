import 'dart:convert' as convert;
import 'package:quiver/strings.dart';

///加解密工具类
class EncryptUtil {
  ///Base64加密
  static String base64Encode(String? data) {
    if (isBlank(data)) return '';
    var content = convert.utf8.encode(data!);
    var digest = convert.base64Encode(content);
    return digest;
  }

  ///Base64解密
  static String base64Decode(String? data) {
    if (isBlank(data)) return '';
    List<int> bytes = convert.base64Decode(data!);
    String result = convert.utf8.decode(bytes);
    return result;
  }
}
