import 'package:shared_preferences/shared_preferences.dart';

class CachedHelper {
  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveString({required String key, required String value}) async {
    return await _sharedPreferences!.setString(key, value);
  }

  static String? getString({required String key}) {
    return _sharedPreferences!.getString(key);
  }


  static Future<bool> saveBool({required String key, required bool value}) async {
    return await _sharedPreferences!.setBool(key, value);
  }

  static bool? getBooleon({required String key}) {
    return _sharedPreferences!.getBool(key);
  }

  static Future<bool> clearData() async {
    return await _sharedPreferences!.clear();
  }
}
