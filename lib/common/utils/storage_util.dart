import 'dart:convert';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'encrypt_util.dart';

/// SharedPreferences管理类
class StorageUtil {
  static late final StorageUtil _singleton = StorageUtil._internal();
  SharedPreferences? _prefs;

  factory StorageUtil() => _singleton;

  StorageUtil._internal();

  Future init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object
  Future<bool>? putObject(String key, Object? value) {
    if (_prefs == null) return null;
    return _prefs?.setString(
        key, value == null ? "" : EncryptUtil.base64Encode(json.encode(value)));
  }

  /// get Object
  T getObj<T>(String key, T Function(Map v) f, {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue! : f(map);
  }

  Map? getObject(String key) {
    if (_prefs == null) return null;
    String? _data = _prefs?.getString(key);
    return isBlank(_data) ? null : json.decode(EncryptUtil.base64Decode(_data));
  }

  String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs?.getString(key) ?? defValue;
  }

  Future<bool>? putString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs?.setString(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs?.getBool(key) ?? defValue;
  }

  Future<bool>? putBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs?.setBool(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs?.getInt(key) ?? defValue;
  }

  Future<bool>? putInt(String key, int value) {
    if (_prefs == null) return null;
    return _prefs?.setInt(key, value);
  }

  bool? haveKey(String key) {
    if (_prefs == null) return null;
    return getKeys()?.contains(key);
  }

  Set<String>? getKeys() {
    if (_prefs == null) return null;
    return _prefs?.getKeys();
  }

  Future<bool>? remove(String key) {
    if (_prefs == null) return null;
    return _prefs?.remove(key);
  }

  Future<bool>? clear() {
    if (_prefs == null) return null;
    return _prefs?.clear();
  }

  bool isInitialized() {
    return _prefs != null;
  }
}
