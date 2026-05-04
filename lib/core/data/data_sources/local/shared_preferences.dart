import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> putValue({
    required String key,
    required String value,
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  Future<String?> getValue({
    required String key,
  }) async {
    return sharedPreferences.getString(key);
  }

  Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      await sharedPreferences.setString(key, value);
      return true;
    }
    if (value is int) {
      await sharedPreferences.setInt(key, value);
      return true;
    }
    if (value is bool) {
      await sharedPreferences.setBool(key, value);
      return true;
    }

    if (value is double) {
      await sharedPreferences.setDouble(key, value);
      return true;
    }

    return null;
  }

  Future<bool> removeData({
    required String key,
  }) async
  {
    return await sharedPreferences.remove(key);
  }
}