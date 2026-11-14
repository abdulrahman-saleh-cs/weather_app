import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Object? getData({required String key}) => _prefs.get(key);

  String? getString({required String key}) => _prefs.getString(key);

  Future<bool> saveData({required String key, required Object value}) async {
    if (value is bool) return _prefs.setBool(key, value);
    if (value is String) return _prefs.setString(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is List<String>) return _prefs.setStringList(key, value);
    throw ArgumentError('Unsupported type: ${value.runtimeType}');
  }

  bool containsKey({required String key}) => _prefs.containsKey(key);

  Future<bool> removeData({required String key}) => _prefs.remove(key);

  Future<bool> clearData() => _prefs.clear();
}