import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// 用来做shared_preferences的存储,数据存储是异步的,读取是同步的
class SpUtil {
  static SpUtil? _instance;

  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences? _spf;

  SpUtil._();

  Future<void> _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    if (_instance == null) {
      _instance = SpUtil._();
      await _instance!._init();
    }
    return _instance!;
  }

  // 判断是否存在数据
  bool hasKey(String key) {
    Set keys = getKeys() ?? {};
    return keys.contains(key);
  }

  Set<String>? getKeys() {
    return _spf?.getKeys();
  }

  Object? get(String key) {
    return _spf?.get(key);
  }

  /// 如果你直接调用getString，主线程会等待加载sp的线程加载完毕
  String? getString(String key) {
    return _spf?.getString(key);
  }

  Future<bool>? putString(String key, String value) {
    return _spf?.setString(key, value);
  }

  bool? getBool(String key) {
    return _spf?.getBool(key);
  }

  Future<bool>? putBool(String key, bool value) {
    return _spf?.setBool(key, value);
  }

  int? getInt(String key) {
    return _spf?.getInt(key);
  }

  Future<bool>? putInt(String key, int value) {
    return _spf?.setInt(key, value);
  }

  double? getDouble(String key) {
    return _spf?.getDouble(key);
  }

  Future<bool>? putDouble(String key, double value) {
    return _spf?.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _spf?.getStringList(key);
  }

  Future<bool>? putStringList(String key, List<String> value) {
    return _spf?.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    return _spf?.get(key);
  }

  Future<bool>? remove(String key) {
    return _spf?.remove(key);
  }

  Future<bool>? clear() {
    return _spf?.clear();
  }
}
