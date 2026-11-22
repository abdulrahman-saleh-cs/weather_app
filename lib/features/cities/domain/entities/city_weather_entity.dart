import 'package:equatable/equatable.dart';

/// Small "right now" summary shown on a saved city card.
class CityWeatherEntity extends Equatable {
  final int temperature;
  final int maxTemp;
  final int minTemp;
  final int weatherCode;
  final bool isDay;

  const CityWeatherEntity({
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.isDay,
  });

  @override
  List<Object?> get props => [temperature, maxTemp, minTemp, weatherCode, isDay];
}
