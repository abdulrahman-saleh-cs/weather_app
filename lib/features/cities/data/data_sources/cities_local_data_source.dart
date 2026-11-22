import 'dart:convert';
import 'package:weather_app/core/databases/cache/cache_helper.dart';
import '../models/models.dart';

abstract class CitiesLocalDataSource {
  List<CityModel> getSavedCities();
  Future<void> saveCities(List<CityModel> cities);
  CityModel? getSelectedCity();
  Future<void> saveSelectedCity(CityModel city);
}

class CitiesLocalDataSourceImpl implements CitiesLocalDataSource {
  final CacheHelper cache;

  CitiesLocalDataSourceImpl({required this.cache});

  static const _savedKey = 'saved_cities';
  static const _selectedKey = 'selected_city';

  @override
  List<CityModel> getSavedCities() {
    final raw = cache.getString(key: _savedKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return [for (final e in list) CityModel.fromJson(e as Map<String, dynamic>)];
  }

  @override
  Future<void> saveCities(List<CityModel> cities) async {
    await cache.saveData(
      key: _savedKey,
      value: jsonEncode([for (final c in cities) c.toJson()]),
    );
  }

  @override
  CityModel? getSelectedCity() {
    final raw = cache.getString(key: _selectedKey);
    if (raw == null) return null;
    return CityModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSelectedCity(CityModel city) async {
    await cache.saveData(key: _selectedKey, value: jsonEncode(city.toJson()));
  }
}
