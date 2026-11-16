import 'package:equatable/equatable.dart';

import 'daily_forecast_entity.dart';
import 'hourly_forecast_entity.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final double temperature;
  final String condition;
  final double tempMax;
  final double tempMin;
  final int humidity;
  final double windSpeed;
  final int rainChance;
  final List<HourlyForecastEntity> hourlyForecast;
  final List<DailyForecastEntity> dailyForecast;
  final int weatherCode;
  final bool isDay;
  final String image;

  const WeatherEntity({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.tempMax,
    required this.tempMin,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.weatherCode,
    required this.isDay,
    required this.image,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    condition,
    tempMax,
    tempMin,
    humidity,
    windSpeed,
    rainChance,
    hourlyForecast,
    dailyForecast,
    weatherCode,
    isDay,
    image,
  ];
}