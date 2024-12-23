import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _isFirstTimeKey = 'is_first_time';

  Future<bool> getIsFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setIsFirstTimeUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, value);
  }
}
