import 'package:weather_app/features/cities/domain/entities/entities.dart';

class CityWeatherModel extends CityWeatherEntity {
  const CityWeatherModel({
    required super.temperature,
    required super.maxTemp,
    required super.minTemp,
    required super.weatherCode,
    required super.isDay,
  });

  factory CityWeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    return CityWeatherModel(
      temperature: (current['temperature_2m'] as num).round(),
      weatherCode: current['weather_code'] as int,
      isDay: (current['is_day'] as num) == 1,
      maxTemp: ((daily['temperature_2m_max'] as List).first as num).round(),
      minTemp: ((daily['temperature_2m_min'] as List).first as num).round(),
    );
  }
}
