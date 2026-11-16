import '../../domain/entities/entities.dart';

class HourlyForecastModel extends HourlyForecastEntity {
  const HourlyForecastModel({
    required super.time,
    required super.temperature,
    required super.image,
    required super.weatherCode,
    required super.isDay,
  });
}
