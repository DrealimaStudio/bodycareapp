import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static Future<void> setExerciseDone(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getExerciseDone(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}