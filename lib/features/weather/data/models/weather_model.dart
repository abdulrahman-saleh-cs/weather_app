import 'package:weather_app/features/weather/domain/entities/entities.dart';
import 'package:weather_app/core/utils/utils.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
    required super.tempMax,
    required super.tempMin,
    required super.humidity,
    required super.windSpeed,
    required super.rainChance,
    required super.hourlyForecast,
    required super.dailyForecast,
    required super.weatherCode,
    required super.isDay,
    required super.image,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'];
    final daily = json['daily'];
    final hourly = json['hourly'];

    return WeatherModel(
      cityName: cityName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      condition: _mapWeatherCodeToCondition(current['weather_code']),
      tempMax: (daily['temperature_2m_max'][0] as num).toDouble(),
      tempMin: (daily['temperature_2m_min'][0] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      rainChance: (daily['precipitation_probability_max'][0] as num).toInt(),
      hourlyForecast: _parseHourly(hourly),
      dailyForecast: _parseDaily(daily),
      weatherCode: current['weather_code'] as int,
      isDay: current['is_day'] == 1,
      image: WeatherCodeMapper.image(
        current['weather_code'] as int,
        isDay: current['is_day'] == 1,
      ),
    );
  }

  static String _mapWeatherCodeToCondition(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Cloudy';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }

  static List<HourlyForecastModel> _parseHourly(Map<String, dynamic> hourly) {
    final times = hourly['time'] as List;
    final temps = hourly['temperature_2m'] as List;
    final codes = hourly['weather_code'] as List;
    final isDay = hourly['is_day'] as List;

    return List.generate(24, (i) => HourlyForecastModel(
      time: times[i].toString().split('T').last,
      temperature: (temps[i] as num).toDouble(),
      image: WeatherCodeMapper.image(
        codes[i] as int,
        isDay: isDay[i] == 1,
      ),
    ));
  }
  static List<DailyForecastModel> _parseDaily(Map<String, dynamic> daily) {
    final times = daily['time'] as List;
    final maxTemps = daily['temperature_2m_max'] as List;
    final minTemps = daily['temperature_2m_min'] as List;
    final codes = daily['weather_code'] as List;

    return List.generate(times.length, (i) => DailyForecastModel(
      day: times[i].toString(),
      maxTemp: (maxTemps[i] as num).round(),
      minTemp: (minTemps[i] as num).round(),
      image: WeatherCodeMapper.image(codes[i] as int),
    ));
  }}

class HourlyForecastModel extends HourlyForecastEntity {
  const HourlyForecastModel({
    required super.time,
    required super.temperature,
    required super.image,
  });
}

class DailyForecastModel extends DailyForecastEntity {
  const DailyForecastModel({
    required super.day,
    required super.maxTemp,
    required super.minTemp,
    required super.image,
  });
}
