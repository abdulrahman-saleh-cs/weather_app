import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing local data caching using SharedPreferences.
class CacheHelper {
  late final SharedPreferences _prefs;

  /// Initializes the [SharedPreferences] instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Retrieves raw data associated with the given [key].
  Object? getData({required String key}) => _prefs.get(key);

  /// Retrieves a string associated with the given [key].
  String? getString({required String key}) => _prefs.getString(key);

  /// Saves [value] associated with [key] to local storage.
  /// Supports bool, String, int, double, and List<String>.
  Future<bool> saveData({required String key, required Object value}) async {
    if (value is bool) return _prefs.setBool(key, value);
    if (value is String) return _prefs.setString(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is List<String>) return _prefs.setStringList(key, value);
    throw ArgumentError('Unsupported type: ${value.runtimeType}');
  }

  /// Returns true if the cache contains the given [key].
  bool containsKey({required String key}) => _prefs.containsKey(key);

  /// Removes the data associated with the given [key].
  Future<bool> removeData({required String key}) => _prefs.remove(key);

  /// Clears all data from the cache.
  Future<bool> clearData() => _prefs.clear();
}
