import 'package:weather_app/core/databases/api/api.dart';
import '../models/models.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
    required String cityName,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiConsumer api;

  WeatherRemoteDataSourceImpl({required this.api});

  @override
  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
    required String cityName,
  }) async {
    final response = await api.get(
      '${EndPoints.forecastBaseUrl}${EndPoints.forecast}',
      queryParameters: {
        ApiKeys.lat: lat,
        ApiKeys.lon: lon,
        ApiKeys.current:
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,is_day',
        ApiKeys.hourly: 'temperature_2m,weather_code,is_day',
        ApiKeys.daily:
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        ApiKeys.timezone: 'auto',
      },
    );

    return WeatherModel.fromJson(response, cityName);
  }
}
