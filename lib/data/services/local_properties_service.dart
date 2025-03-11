import 'package:shared_preferences/shared_preferences.dart';

class LocalPropertiesService {
  final SharedPreferences _sharedPreferences;

  LocalPropertiesService(this._sharedPreferences);

  Future<void> setProperty(String key, dynamic value) async {
    if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is int) {
      await _sharedPreferences.setInt(key, value);
    }
  }

  T? getProperty<T>(String key) {
    if (T == String) {
      return _sharedPreferences.getString(key) as T?;
    } else if (T == bool) {
      return _sharedPreferences.getBool(key) as T?;
    } else if (T == int) {
      return _sharedPreferences.getInt(key) as T?;
    }
    return null;
  }

  Future<void> removeProperty(String key) => _sharedPreferences.remove(key);

  Future<void> clearProperties() => _sharedPreferences.clear();

  bool hasProperty(String key) => _sharedPreferences.containsKey(key);
}
