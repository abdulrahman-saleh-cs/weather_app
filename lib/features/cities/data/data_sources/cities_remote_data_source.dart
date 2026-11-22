import 'package:weather_app/core/databases/api/api.dart';
import 'package:weather_app/features/cities/domain/entities/entities.dart';
import '../models/models.dart';

abstract class CitiesRemoteDataSource {
  Future<List<CityModel>> searchCities(String query);
  Future<List<CityWeatherModel>> getCitiesWeather(List<CityEntity> cities);
}

class CitiesRemoteDataSourceImpl implements CitiesRemoteDataSource {
  final ApiConsumer api;

  CitiesRemoteDataSourceImpl({required this.api});

  static const int _maxResults = 10;

  @override
  Future<List<CityModel>> searchCities(String query) async {
    final response = await api.get(
      '${EndPoints.geocodingBaseUrl}${EndPoints.search}',
      queryParameters: {
        'name': query,
        'count': _maxResults,
        'language': 'en',
        'format': 'json',
      },
    );

    // The API omits "results" entirely when nothing matches.
    final results = (response['results'] as List?) ?? const [];
    return [
      for (final item in results) CityModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// One request for all cities: Open-Meteo accepts comma separated coordinates.
  @override
  Future<List<CityWeatherModel>> getCitiesWeather(List<CityEntity> cities) async {
    final response = await api.get(
      '${EndPoints.forecastBaseUrl}${EndPoints.forecast}',
      queryParameters: {
        ApiKeys.lat: cities.map((c) => c.latitude).join(','),
        ApiKeys.lon: cities.map((c) => c.longitude).join(','),
        ApiKeys.current: 'temperature_2m,weather_code,is_day',
        ApiKeys.daily: 'temperature_2m_max,temperature_2m_min',
        ApiKeys.timezone: 'auto',
        'forecast_days': 1,
      },
    );

    // One location returns an object, several return a list.
    final items = response is List ? response : [response];
    return [
      for (final item in items) CityWeatherModel.fromJson(item as Map<String, dynamic>),
    ];
  }
}
