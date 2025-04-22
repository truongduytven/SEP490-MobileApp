import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final ValueNotifier<int> roleNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<String> avatarNotifier = ValueNotifier<String>("");
  static final ValueNotifier<String> fullNameNotifier = ValueNotifier<String>("");
  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();
  SharedPreferences? _prefs;

  factory SharedPrefsHelper() {
    return _instance;
  }

  SharedPrefsHelper._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    if (key == 'roleId') {
      roleNotifier.value = value;
    }
    await _prefs?.setInt(key, value);
  }

  Future<void> setString(String key, String value) async {
    if (key == 'avatar') {
      avatarNotifier.value = value;
    }
    if (key == 'fullName') {
      fullNameNotifier.value = value;
    }
    await _prefs?.setString(key, value);
  }

  Future<void> clear() async {
    final isFirstTimeKey = _prefs!.getBool('is_first_time');
    roleNotifier.value = 0;
    await _prefs?.clear();

    if (isFirstTimeKey != null) {
      await _prefs?.setBool('is_first_time', isFirstTimeKey);
    }
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
